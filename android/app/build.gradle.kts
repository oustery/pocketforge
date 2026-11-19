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
    }

    buildTypes {
        release {
            // TODO(M6): собственный release-keystore из secrets.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
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
            // Статический бинарник proot — стриппинг не нужен (и NDK-инструменты
            // не должны вызываться: в CI-песочницах NDK может отсутствовать).
            doNotStrip += "**/*.so"
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
