allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
    
    val configureAndroid = { 
        val android = project.extensions.findByName("android")
        if (android != null) {
            try {
                val compileSdkVersionMethod = android.javaClass.getMethod("compileSdkVersion", Int::class.javaPrimitiveType)
                compileSdkVersionMethod.invoke(android, 36)
            } catch (e: Exception) {
                try {
                    val compileSdkMethod = android.javaClass.getMethod("setCompileSdk", java.lang.Integer::class.java)
                    compileSdkMethod.invoke(android, 36)
                } catch (e2: Exception) {}
            }
            try {
                val defaultConfig = android.javaClass.getMethod("getDefaultConfig").invoke(android)
                val targetSdkMethod = defaultConfig.javaClass.getMethod("setTargetSdk", java.lang.Integer::class.java)
                targetSdkMethod.invoke(defaultConfig, 36)
            } catch (e: Exception) {}
        }
    }

    if (project.state.executed) {
        configureAndroid()
    } else {
        project.afterEvaluate {
            configureAndroid()
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
