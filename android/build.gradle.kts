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

subprojects {
    val project = this
    fun configureNamespace() {
        if (project.hasProperty("android")) {
            val android = project.extensions.getByName("android")
            try {
                val namespaceMethod = android.javaClass.getMethod("setNamespace", String::class.java)
                val getNamespaceMethod = android.javaClass.getMethod("getNamespace")
                if (getNamespaceMethod.invoke(android) == null) {
                    val packageName = if (project.name == "isar_flutter_libs") {
                        "dev.isar.isar_flutter_libs"
                    } else {
                        "com.vivapro.${project.name.replace("-", ".").replace("_", ".")}"
                    }
                    namespaceMethod.invoke(android, packageName)
                }
            } catch (e: Exception) {
                // Ignore
            }
        }
    }

    if (project.state.executed) {
        configureNamespace()
    } else {
        project.afterEvaluate {
            configureNamespace()
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
