plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.pocketforge"
    compileSdk = flutter.compileSdkVersion
    // NDK не нужен: libproot.so — готовый статический бинарник в jniLibs,
    // нативного кода для компиляции в проекте нет.

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.example.pocketforge"
        // PocketForge: Android 8.0+, целевой уровень 28 — осознанное решение
        // (распространение вне Play, lenient FGS/scoped-storage правила).
        minSdk = 26
        targetSdk = 28
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        // Приложение поставляется только для arm64: фильтр убирает чужие ABI
        // из нативных библиотек плагинов (~0.3 МБ лишнего в APK).
        ndk {
            abiFilters += listOf("arm64-v8a")
        }
    }

    signingConfigs {
        create("release") {
            // Релизный ключ приходит из CI-секретов через env (см. release.yml).
            // Локально (без env) config пуст — release падает на debug-ключ.
            val storePath = System.getenv("ANDROID_KEYSTORE_PATH")
            val storePass = System.getenv("ANDROID_KEYSTORE_PASSWORD")
            val alias = System.getenv("ANDROID_KEY_ALIAS")
            val keyPass = System.getenv("ANDROID_KEY_PASSWORD")
            if (storePath != null && storePass != null && alias != null && keyPass != null) {
                storeFile = file(storePath)
                storePassword = storePass
                keyAlias = alias
                keyPassword = keyPass
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (signingConfigs.getByName("release").storeFile != null) {
                signingConfigs.getByName("release")
            } else {
                // Локальная сборка без env: debug-ключ. TODO(M6) закрыт —
                // CI подписывает release-ключом из секретов.
                signingConfigs.getByName("debug")
            }
            // R8: ужимаем Kotlin/Java-часть (dex) и неиспользуемые ресурсы.
            // Нативные .so и Dart AOT (libapp.so) R8 не трогает — их размер
            // определяется стриппингом (см. packaging.jniLibs ниже).
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }
    }

    lint {
        // lintVital на CI падал по Metaspace и валил assembleRelease вместе
        // с lint-воркерами модулей плагинов; для распространения вне Play
        // релизный lint не должен блокировать сборку APK.
        checkReleaseBuilds = false
        abortOnError = false
    }

    packaging {
        // libproot.so должен быть извлечён на диск (proot запускается как процесс).
        jniLibs {
            useLegacyPackaging = true
            // Стриппинг остальных .so включён: без него libflutter.so едет в
            // APK с отладочными DWARF-символами (~43 МБ вместо ~9 МБ).
            // AGP стрипает через NDK; если NDK недоступен, он упакует
            // библиотеку как есть с warning — сборка не падает. Для proot
            // (статический бинарник) стриппинг отключён явно.
            doNotStrip += "**/libproot.so"
            // Чужие ABI плагинов: ndk.abiFilters перекрывается ABI-логикой
            // flutter-плагина, поэтому артефакты x86_64/v7a исключаем напрямую.
            excludes += setOf("lib/x86_64/**", "lib/armeabi-v7a/**")
        }
    }
}

dependencies {
    // FileProvider для установки update-APK (M6).
    implementation("androidx.core:core-ktx:1.15.0")
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
