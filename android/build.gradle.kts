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

    if (project.name != "app") {
        plugins.withId("com.android.library") {
            val androidComponents = extensions.findByName("androidComponents") as? com.android.build.api.variant.AndroidComponentsExtension<*, *, *>
            androidComponents?.finalizeDsl { extension ->
                val libraryExtension = extension as? com.android.build.api.dsl.LibraryExtension
                libraryExtension?.compileSdk = 34
            }
        }
    }

    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

