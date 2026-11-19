# PocketForge: консервативные правила R8.
#
# Код приложения не использует рефлексию: MainActivity и RuntimeService
# удерживаются манифестом, остальные классы статически достижимы.
# Flutter-плагин движка и плагины (secure_storage, image_picker, url_launcher,
# path_provider) подключают свои consumer-rules автоматически, поэтому
# явных -keep правил здесь не требуется.
