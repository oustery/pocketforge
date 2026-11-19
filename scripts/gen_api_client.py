#!/usr/bin/env python3
"""Генератор Dart-клиента OpenCode из живой спецификации /doc.

Использование:
    python3 scripts/gen_api_client.py api/openapi-1.19.6.json

Выход:
    lib/core/api/models.gen.dart  — модели всех компонентов схемы
    lib/core/api/client.gen.dart  — типизированные методы всех операций

Правила:
    - object-схемы → классы с fromJson/toJson;
    - anyOf/oneOf с дискриминатором (одно-значный enum `type` в каждом
      варианте) → статический dispatch (например Event.fromJson);
    - прочие anyOf/oneOf → dynamic;
    - массивы/примитивы → алиасы типов;
    - инлайн-объектные ответы → обёртка {OpName}Response;
    - text/event-stream → Stream<List<int>> (SSE обрабатывает sse.dart);
    - text/x-diff → String, application/octet-stream → List<int>.
"""
from __future__ import annotations

import json
import re
import sys
from pathlib import Path


def pascal(name: str) -> str:
    parts = [p for p in name.replace("-", "_").replace(".", "_").split("_") if p]
    return "".join(p[:1].upper() + p[1:] for p in parts)


def camel(name: str) -> str:
    ps = pascal(name)
    return ps[:1].lower() + ps[1:]


_DART_RESERVED = frozenset(
    """abstract as assert async await base break case catch class const continue
    covariant default deferred do dynamic else enum export extends extension
    external factory false final finally for Function get hide if implements
    import in interface is late library mixin new null on operator part required
    rethrow return sealed set show static super switch sync this throw true try
    typedef var void when while with yield""".split()
)


def sanitize_ident(name: str) -> str:
    """Строит валидный lowerCamelCase идентификатор из произвольной строки."""
    parts = [p for p in re.split(r"[^A-Za-z0-9]+", name) if p]
    if not parts:
        return "param"
    out = parts[0].lower() + "".join(p[:1].upper() + p[1:] for p in parts[1:])
    return out


def kstr(name: str) -> str:
    """Dart-строковый литерал для JSON-ключа (с экранированием $ и кавычек)."""
    s = name.replace("\\", "\\\\").replace("'", "\\'").replace("$", "\\$")
    return f"'{s}'"


def dart_prop(name: str) -> str:
    """Имя поля/параметра: идентификатор или санитизированная версия."""
    if name.isidentifier() and not name.startswith("_") and name not in _DART_RESERVED:
        return name
    s = sanitize_ident(name)
    if not s.isidentifier() or s in _DART_RESERVED:
        s += "_"
    return s


class Gen:
    def __init__(self, spec: dict):
        self.spec = spec
        self.schemas: dict = spec["components"]["schemas"]
        self.classes: list[str] = []      # готовые блоки классов
        self.aliases: dict[str, str] = {}  # schemaName -> dart type
        self.unions: dict[str, tuple[str, dict]] = {}  # name -> (field, map)
        self.union_variants: set[str] = set()
        for sname, s in self.schemas.items():
            if "anyOf" in s or "oneOf" in s:
                u = self.union_dispatch(s)
                if u:
                    self.union_variants.update(u[1].values())

    # ---------- типы ----------

    def resolve(self, schema: dict) -> str:
        """Dart-тип для фрагмента схемы (без регистрация классов)."""
        if schema is None:
            return "dynamic"
        if "$ref" in schema:
            ref = schema["$ref"].rsplit("/", 1)[-1]
            self.ensure_schema(ref)
            return self.aliases.get(ref, pascal(ref))
        t = schema.get("type")
        if isinstance(t, list):
            non_null = [x for x in t if x != "null"]
            if len(non_null) == 1:
                return self.resolve({**schema, "type": non_null[0]})
            return "dynamic"
        if t == "array":
            inner = self.resolve(schema.get("items") or {})
            return f"List<{inner}>"
        if t == "object":
            ap = schema.get("additionalProperties")
            if isinstance(ap, dict):
                v = self.resolve(ap)
                return f"Map<String, {v}>" if v != "dynamic" else "Map<String, dynamic>"
            return "Map<String, dynamic>"
        if t == "string":
            return "String"
        if t == "integer":
            return "int"
        if t == "number":
            return "double"
        if t == "boolean":
            return "bool"
        if "anyOf" in schema or "oneOf" in schema:
            # union-классы генерируются отдельно (ensure_schema); поле — dynamic
            return "dynamic"
        return "dynamic"

    def union_dispatch(self, schema: dict) -> tuple[str, dict] | None:
        """(поле-дискриминатор, {значение: схема}) если anyOf диспетчеризуем."""
        variants = schema.get("anyOf") or schema.get("oneOf")
        if not variants:
            return None
        refs = [v.get("$ref", "").rsplit("/", 1)[-1] if "$ref" in v else None for v in variants]
        if not refs or any(r is None for r in refs):
            return None
        field = None
        mapping: dict[str, str] = {}
        for r in refs:
            sub = self.schemas.get(r)
            if not sub or "properties" not in sub:
                return None
            consts = [
                pn
                for pn, ps in sub["properties"].items()
                if isinstance(ps, dict)
                and ps.get("type") == "string"
                and ps.get("enum")
                and len(ps["enum"]) == 1
            ]
            if len(consts) != 1:
                return None
            f = consts[0]
            if field is None:
                field = f
            elif field != f:
                return None
            mapping[sub["properties"][f]["enum"][0]] = r
        return field, mapping

    def ensure_schema(self, name: str) -> None:
        if name in self.aliases or any(c.startswith(f"class {pascal(name)} ") for c in self.classes):
            return
        schema = self.schemas.get(name)
        if schema is None:
            self.aliases[name] = "dynamic"
            return

        u = self.union_dispatch(schema) if ("anyOf" in schema or "oneOf" in schema) else None
        if u:
            field, mapping = u
            self.unions[name] = (field, mapping)
            self.aliases[name] = "dynamic"  # поле union-типа — dynamic
            return

        t = schema.get("type")
        if t == "array":
            self.aliases[name] = self.resolve(schema.get("items") or {})
            return
        if t == "object" and "properties" not in schema:
            self.aliases[name] = "Map<String, dynamic>"
            return
        if t in ("string", "integer", "number", "boolean") and "properties" not in schema:
            self.aliases[name] = {"string": "String", "integer": "int", "number": "double", "boolean": "bool"}[t]
            return
        props = schema.get("properties")
        if props is None:
            self.aliases[name] = "dynamic"
            return
        self.emit_class(name, schema)

    # ---------- классы ----------

    def emit_class(self, name: str, schema: dict) -> None:
        props = schema.get("properties") or {}
        required = set(schema.get("required") or [])
        fields = []
        for pname, pschema in props.items():
            dt = self.resolve(pschema)
            # варианты union парсим толерантно: реальный сервер может
            # присылать подмножество полей — не падаем на касте
            req = pname in required and name not in self.union_variants
            fields.append(
                {
                    "json": pname,
                    "dart": dart_prop(pname),
                    "type": dt,
                    "req": req,
                }
            )
        cls = pascal(name)
        lines = [f"class {cls} {{", "  /// Создаёт модель из полей."]
        sig = ", ".join(
            (f"required this.{f['dart']}" if f["req"] else f"this.{f['dart']}")
            for f in fields
        )
        lines.append(f"  {cls}({{%n{sig}%n}});" if fields else f"  {cls}();")

        for f in fields:
            decl = f["type"]
            if not f["req"] and decl != "dynamic":
                decl += "?"
            lines.append(f"  final {decl} {f['dart']};")

        # fromJson
        lines.append("")
        lines.append(f"  /// Разбирает JSON в [Object] типа {cls}.")
        lines.append(f"  factory {cls}.fromJson(Map<String, Object?> json) {{")
        args = []
        for f in fields:
            args.append(self.parse_expr(f))
        if args:
            body = "\n".join("      " + a for a in args)
            lines.append(f"    return {cls}(%n{body}%n);")
        else:
            lines.append(f"    return {cls}();")
        lines.append("  }")

        # toJson
        lines.append("")
        lines.append("  /// Сериализует модель в JSON.")
        lines.append("  Map<String, Object?> toJson() => {")
        for f in fields:
            lines.append(f"    {kstr(f['json'])}: {self.dump_expr(f)},")
        lines.append("  };")
        lines.append("}")
        self.classes.append("\n".join(lines))
        self.aliases[name] = cls

    def parse_expr(self, f: dict) -> str:
        j, d, t, req = f["json"], f["dart"], f["type"], f["req"]
        jkey = f"json[{kstr(j)}]"
        if t.startswith("List<"):
            inner = t[5:-1]
            if inner == "dynamic":
                cast = f"({jkey} as List?)?.cast<dynamic>()"
            elif inner in ("String", "int", "double", "bool"):
                conv = {"int": "e as int", "double": "(e as num).toDouble()", "String": "e as String", "bool": "e as bool"}[inner]
                cast = f"({jkey} as List?)?.map((e) => {conv}).toList()"
            else:
                cast = (
                    f"({jkey} as List?)?.map((e) => {inner}.fromJson(e as Map<String, Object?>)).toList()"
                )
            expr = cast if not req else f"({jkey} as List).map((e) => {self._elem_conv(inner)}).toList()"
            if req:
                expr = f"({jkey} as List).map((e) => {self._elem_conv(inner)}).toList()"
            return f"{d}: {expr},"
        if t.startswith("Map<"):
            v = t[4:-1].split(",", 1)[1].strip()
            if v in ("dynamic", "Object?", "Map<String, dynamic>"):
                conv = "v" if v == "dynamic" else "v as Map<String, Object?>"
            elif v in ("String", "int", "bool"):
                conv = f"v as {v}"
            elif v == "double":
                conv = "(v as num).toDouble()"
            else:
                conv = f"{v}.fromJson(v as Map<String, Object?>)"
            if not req:
                return f"{d}: ({jkey} as Map?)?.map((k, v) => MapEntry(k as String, {conv})),"
            return f"{d}: ({jkey} as Map).map((k, v) => MapEntry(k as String, {conv})),"
        if t in ("String", "bool"):
            return f"{d}: {jkey} as {t}," if req else f"{d}: {jkey} as {t}?,"
        if t == "int":
            return f"{d}: ({jkey} as num).toInt()," if req else f"{d}: ({jkey} as num?)?.toInt(),"
        if t == "double":
            return f"{d}: ({jkey} as num).toDouble()," if req else f"{d}: ({jkey} as num?)?.toDouble(),"
        if t == "dynamic":
            return f"{d}: {jkey},"
        # модель
        if req:
            return f"{d}: {t}.fromJson({jkey} as Map<String, Object?>),"
        return f"{d}: ({jkey} as Map<String, Object?>?) == null ? null : {t}.fromJson({jkey} as Map<String, Object?>),"

    def _elem_conv(self, inner: str) -> str:
        if inner == "dynamic":
            return "e"
        if inner == "Map<String, dynamic>":
            return "e as Map<String, Object?>"
        if inner in ("String", "int", "bool"):
            return f"e as {inner}"
        if inner == "double":
            return "(e as num).toDouble()"
        return f"{inner}.fromJson(e as Map<String, Object?>)"

    def dump_expr(self, f: dict) -> str:
        d, t = f["dart"], f["type"]
        if t == "dynamic":
            return d
        if t.startswith("Map<"):
            return d
        if t.startswith("List<"):
            inner = t[5:-1]
            if inner in ("String", "int", "double", "bool", "dynamic") or inner.startswith("Map<"):
                return d
            return f"{d}?.map((e) => e.toJson()).toList()"
        if t in ("String", "int", "double", "bool"):
            return d
        return f"{d}?.toJson()"

    # ---------- union ----------

    def emit_union(self, name: str) -> str:
        field, mapping = self.unions[name]
        cls = pascal(name)
        lines = [
            f"class {cls} {{",
            f"  /// Диспетчеризация anyOf-вариантов по полю '{field}'.",
            f"  static dynamic fromJson(Map<String, Object?> json) {{",
            f"    final t = json[{kstr(field)}] as String?;",
            "    switch (t) {",
        ]
        for value, ref in sorted(mapping.items()):
            lines.append(f"      case {kstr(value)}: return {pascal(ref)}.fromJson(json);")
        lines.append("      default: return UnknownEvent(json);")
        lines.append("    }")
        lines.append("  }")
        lines.append("}")
        return "\n".join(lines)

    # ---------- операции ----------

    def op_method_name(self, op_id: str, used: set) -> str:
        name = camel(op_id.replace(".", "_"))
        base = name
        i = 2
        while name in used:
            name = f"{base}{i}"
            i += 1
        used.add(name)
        return name

    def response_kind(self, op: dict) -> tuple[str, dict | None]:
        """('kind', schema) где kind: model|list|primitive|bytes|sse|dynamic|wrapper."""
        resp = op.get("responses") or {}
        r = resp.get("200") or resp.get("201") or resp.get("default")
        if not r:
            return "dynamic", None
        content = r.get("content") or {}
        if "text/event-stream" in content:
            return "sse", None
        if "application/octet-stream" in content:
            return "bytes", None
        if "text/x-diff; charset=utf-8" in content:
            return "primitive", {"type": "string"}
        js = content.get("application/json")
        if not js:
            return "dynamic", None
        sc = js.get("schema") or {}
        if "$ref" in sc:
            ref = sc["$ref"].rsplit("/", 1)[-1]
            self.ensure_schema(ref)
            t = self.aliases.get(ref, pascal(ref))
            if t.startswith("List<"):
                return "list", sc
            if t in ("String", "int", "double", "bool"):
                return "primitive", {"type": t.lower()}
            if t == "Map<String, dynamic>" or t == "dynamic":
                return "dynamic", None
            return "model", sc
        t = sc.get("type")
        if t == "array":
            return "list", sc
        if t == "string":
            return "primitive", sc
        if t == "integer":
            return "primitive", sc
        if t == "boolean":
            return "primitive", sc
        if t == "object" or "properties" in sc:
            return "wrapper", sc
        return "dynamic", None

    def emit_op(self, path: str, method: str, op: dict, used: set) -> str:
        name = self.op_method_name(op["operationId"], used)
        params = op.get("parameters") or []
        path_params = [p for p in params if p.get("in") == "path"]
        query_params = [p for p in params if p.get("in") == "query"]

        rb = (op.get("requestBody") or {}).get("content") or {}
        body_type = "dynamic"
        has_body = "application/json" in rb
        if has_body:
            bs = rb["application/json"].get("schema") or {}
            if "$ref" in bs:
                ref = bs["$ref"].rsplit("/", 1)[-1]
                self.ensure_schema(ref)
                t = self.aliases.get(ref, pascal(ref))
                body_type = t if t not in ("String", "int", "double", "bool", "Map<String, dynamic>") else None
                if body_type is None:
                    body_type = "dynamic"
            else:
                body_type = "dynamic"

        kind, rsc = self.response_kind(op)

        wname = pascal(op["operationId"]) + "Response"
        sig_params = []
        for p in path_params:
            pn = dart_prop(camel(p["name"]))
            pt = {"string": "String", "integer": "int", "number": "double", "boolean": "bool"}.get(p.get("type"), "String")
            sig_params.append(f"required {pt} {pn}")
        for p in query_params:
            pn = dart_prop(camel(p["name"]))
            pt = {"string": "String", "integer": "int", "number": "double", "boolean": "bool"}.get(p.get("type"), "String")
            if p.get("required"):
                sig_params.append(f"required {pt} {pn}")
            else:
                sig_params.append(f"{pt}? {pn}")
        if has_body:
            if body_type == "dynamic":
                sig_params.append("Map<String, Object?>? body")
            else:
                sig_params.append(f"{body_type}? body")

        doc = f"  /// `{method.upper()} {path}` — {op.get('summary') or op.get('operationId')}"
        ret = {
            "model": self.aliases.get(rsc["$ref"].rsplit("/", 1)[-1], pascal(rsc["$ref"].rsplit("/", 1)[-1])) if rsc and "$ref" in rsc else "dynamic",
            "list": None,  # вычислим ниже
            "primitive": {"string": "String", "integer": "int", "boolean": "bool"}.get((rsc or {}).get("type"), "dynamic"),
            "bytes": "List<int>",
            "sse": "Stream<List<int>>",
            "dynamic": "dynamic",
            "wrapper": wname,
        }
        if kind == "list":
            if rsc and "$ref" in rsc:
                inner = self.aliases.get(rsc["$ref"].rsplit("/", 1)[-1], "dynamic")
                ret["list"] = f"List<{inner}>"
            else:
                inner = self.resolve(rsc.get("items") or {}) if rsc else "dynamic"
                ret["list"] = f"List<{inner}>"
        ret_t = ret[kind]

        lines = [doc]
        params_sig = (", ".join(sig_params))
        sig_txt = f"({{%n{params_sig}%n}})" if sig_params else "()"
        lines.append(f"  Future<{ret_t}> {name}{sig_txt} async {{")
        # путь с параметрами
        pp = list(path)
        path_expr = f"'{path}'"
        if path_params:
            subs = []
            for p in path_params:
                pn = dart_prop(camel(p["name"]))
                subs.append(f".replaceAll('{{{p['name']}}}', Uri.encodeComponent({pn}.toString()))")
            path_expr = "'" + path + "'" + "".join(subs)
        qp = ""
        if query_params:
            entries = ", ".join(
                f"if ({dart_prop(camel(p['name']))} != null) {kstr(p['name'])}: {dart_prop(camel(p['name']))}"
                for p in query_params
            )
            qp = f"queryParameters: {{%n{entries},%n}},"
        data = ""
        if has_body:
            if body_type == "dynamic":
                data = "data: body,"
            else:
                data = "data: body?.toJson(),"

        rt = "Object?" if kind in ("model", "wrapper", "dynamic") else (
            "List<dynamic>" if kind == "list"
            else "String" if kind == "primitive"
            else "ResponseBody" if kind == "sse"
            else "List<int>"
        )
        extra_opts = ""
        if kind == "primitive":
            extra_opts = "responseType: ResponseType.plain,"
        if kind == "bytes":
            extra_opts = "responseType: ResponseType.bytes,"
        if kind == "sse":
            extra_opts = "responseType: ResponseType.stream,"

        opt_entries = [f"method: '{method.upper()}'", extra_opts] if extra_opts else [f"method: '{method.upper()}'"]
        opts = f"Options(%n{', '.join(opt_entries)}%n)"

        if kind == "sse":
            lines.append(f"    final res = await _dio.get<ResponseBody>({path_expr},{qp}")
            lines.append(f"      options: {opts},")
            lines.append("    );")
            lines.append("    return res.data!.stream;")
        else:
            q = f"{qp}" if qp else ""
            d = f"{data}" if data else ""
            lines.append(f"    final res = await _dio.request<{rt}>({path_expr},")
            if q:
                lines.append(f"      {q}")
            if d:
                lines.append(f"      {d}")
            lines.append(f"      options: {opts},")
            lines.append("    );")
            lines.append(self._postamble(kind, rsc, wname))
        lines.append("  }")
        return "\n".join(lines)

    def _postamble(self, kind: str, rsc: dict | None, wname: str = "WrapperClass") -> str:
        if kind == "model":
            ref = rsc["$ref"].rsplit("/", 1)[-1]
            t = self.aliases.get(ref, pascal(ref))
            return f"    return {t}.fromJson(res.data! as Map<String, Object?>);"
        if kind == "wrapper":
            return f"    return {wname}.fromJson(res.data! as Map<String, Object?>);"
        if kind == "list":
            if rsc and "$ref" in rsc:
                inner = self.aliases.get(rsc["$ref"].rsplit("/", 1)[-1], "dynamic")
            else:
                inner = self.resolve((rsc or {}).get("items") or {})
            conv = self._elem_conv(inner)
            return f"    return (res.data! as List).map((e) => {conv}).toList();"
        if kind == "primitive":
            if (rsc or {}).get("type") == "integer":
                return "    return int.parse(res.data! as String);"
            if (rsc or {}).get("type") == "boolean":
                return "    return (res.data! as String).toLowerCase() == 'true';"
            return "    return res.data! as String;"
        if kind == "bytes":
            return "    return res.data!;"
        return "    return res.data;"

    # ---------- сборка ----------

    def generate(self) -> tuple[str, str]:
        # 1. классы/алиасы для всех схем
        for name in self.schemas:
            self.ensure_schema(name)

        # 2. union-классы
        union_blocks = [self.emit_union(n) for n in self.unions]
        unknown = (
            "/// Заглушка для неизвестных вариантов union.\nclass UnknownEvent {\n"
            "  /// Создаёт обёртку над сырым JSON.\n  UnknownEvent(this.raw);\n\n"
            "  /// Сырой JSON события.\n  final Map<String, Object?> raw;\n}"
        )

        models_header = (
            "// GENERATED - DO NOT EDIT BY HAND\n"
            "// Сгенерировано scripts/gen_api_client.py из спецификации opencode.\n\n"
        )
        models = models_header + unknown + "\n\n" + "\n\n".join(union_blocks + self.classes) + "\n"

        # 3. клиент
        ops_lines = []
        used: set = set()
        wrappers: list[str] = []
        for path, methods in self.spec["paths"].items():
            for method, op in methods.items():
                if not isinstance(op, dict) or "operationId" not in op:
                    continue
                block = self.emit_op(path, method, op, used)
                # wrapper: заменим маркер на конкретный класс и сгенерируем его
                kind, rsc = self.response_kind(op)
                if kind == "wrapper":
                    wname = pascal(op["operationId"]) + "Response"
                    wrappers.append(self.make_wrapper(wname, rsc))
                ops_lines.append(block)

        client_header = (
            "// GENERATED - DO NOT EDIT BY HAND\n"
            "// Сгенерировано scripts/gen_api_client.py из спецификации opencode.\n"
            "import 'package:dio/dio.dart';\n\n"
            "import 'models.gen.dart';\n\n"
            "/// Типизированные методы всех операций opencode serve.\n"
            "class OpenCodeApiGen {\n"
            "  /// Создаёт клиент поверх готового [Dio].\n"
            "  OpenCodeApiGen(this._dio);\n\n"
            "  final Dio _dio;\n\n"
        )
        client = client_header + "\n\n".join(ops_lines) + "\n}\n"

        if wrappers:
            models += "\n" + "\n\n".join(wrappers) + "\n"
        return models, client

    def make_wrapper(self, wname: str, schema: dict) -> str:
        sub = Gen(self.spec)
        sub.schemas = self.schemas
        block = sub.emit_class_inline(wname, schema)
        return block

    def emit_class_inline(self, name: str, schema: dict) -> str:
        # как emit_class, но возвращает строку и регистрирует типы в текущем gen
        props = schema.get("properties") or {}
        required = set(schema.get("required") or [])
        fields = []
        for pname, pschema in props.items():
            dt = self.resolve(pschema)
            fields.append({"json": pname, "dart": dart_prop(pname), "type": dt, "req": pname in required})
        lines = [f"class {name} {{", "  /// Создаёт модель из полей."]
        sig = ", ".join(
            (f"required this.{f['dart']}" if f["req"] else f"this.{f['dart']}")
            for f in fields
        )
        lines.append(f"  {name}({{%n{sig}%n}});" if fields else f"  {name}();")
        for f in fields:
            decl = f["type"]
            if not f["req"] and decl != "dynamic":
                decl += "?"
            lines.append(f"  final {decl} {f['dart']};")
        lines.append("")
        lines.append(f"  /// Разбирает JSON в [Object] типа {name}.")
        lines.append(f"  factory {name}.fromJson(Map<String, Object?> json) {{")
        args = [self.parse_expr(f) for f in fields]
        if args:
            body = "\n".join("      " + a for a in args)
            lines.append(f"    return {name}(%n{body}%n);")
        else:
            lines.append(f"    return {name}();")
        lines.append("  }")
        lines.append("")
        lines.append("  /// Сериализует модель в JSON.")
        lines.append("  Map<String, Object?> toJson() => {")
        for f in fields:
            lines.append(f"    {kstr(f['json'])}: {self.dump_expr(f)},")
        lines.append("  };")
        lines.append("}")
        return "\n".join(lines)


def main() -> None:
    spec_path = Path(sys.argv[1] if len(sys.argv) > 1 else "api/openapi-1.19.6.json")
    out_dir = Path(__file__).resolve().parent.parent / "lib" / "core" / "api"
    out_dir.mkdir(parents=True, exist_ok=True)

    spec = json.loads(spec_path.read_text(encoding="utf-8"))
    gen = Gen(spec)
    models, client = gen.generate()
    models = models.replace("%n", "\n")
    client = client.replace("%n", "\n")

    (out_dir / "models.gen.dart").write_text(models, encoding="utf-8")
    (out_dir / "client.gen.dart").write_text(client, encoding="utf-8")
    n_ops = client.count("Future<")
    print(f"OK: {len(gen.classes)} классов, {len(gen.unions)} union-диспетчеров, {n_ops} операций")


if __name__ == "__main__":
    main()
