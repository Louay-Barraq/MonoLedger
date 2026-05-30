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
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

subprojects {
    val projectObj = this
    val configureProject = {
        val android = projectObj.extensions.findByName("android")
        if (android != null) {
            try {
                // Force compileSdk to 36 to resolve android:attr/lStar AAPT linking errors in older library dependencies
                val targetMethods = listOf("compileSdkVersion", "setCompileSdkVersion", "setCompileSdk", "compileSdk")
                for (methodName in targetMethods) {
                    val method = android::class.java.methods.find {
                        it.name == methodName && it.parameterTypes.size == 1 && (it.parameterTypes[0] == Int::class.java || it.parameterTypes[0] == java.lang.Integer::class.java)
                    }
                    if (method != null) {
                        method.invoke(android, 36)
                        break
                    }
                }

                val getNamespace = android::class.java.methods.find { it.name == "getNamespace" }
                val setNamespace = android::class.java.methods.find { it.name == "setNamespace" }
                if (getNamespace != null && setNamespace != null) {
                    val currentNamespace = getNamespace.invoke(android) as? String
                    if (currentNamespace == null || currentNamespace.isEmpty()) {
                        var newNamespace = projectObj.group.toString()
                        if (newNamespace.isEmpty() || newNamespace == "null") {
                            newNamespace = "com.monoledger.${projectObj.name.replace('-', '_')}"
                        }
                        if (projectObj.name == "isar_flutter_libs") {
                            newNamespace = "dev.isar.isar_flutter_libs"
                        }
                        setNamespace.invoke(android, newNamespace)
                    }
                }
            } catch (e: Exception) {
                // Ignore reflection errors
            }
        }
    }

    if (projectObj.state.executed) {
        configureProject()
    } else {
        projectObj.afterEvaluate {
            configureProject()
        }
    }
}
