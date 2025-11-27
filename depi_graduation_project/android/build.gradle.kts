buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Gradle plugin for Android
        classpath("com.android.tools.build:gradle:8.2.1")
        // NOTE: Do not place your application dependencies here; they belong
        // in the individual module build.gradle.kts files
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// --- Custom build directory on same drive as project ---
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)
}

// Ensure app module evaluates first
subprojects {
    project.evaluationDependsOn(":app")
}

// Override clean task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
