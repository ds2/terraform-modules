plugins {
    id("org.ysb33r.terraform.base") version "0.9.0"
    id("net.researchgate.release") version "2.8.1"
}

tasks.register("build") {
    group = "Build"
    description = "nothing to build for now"
}

tasks.register("clean") {
    group = "Build"
    description = "not really something to clean"
}

release {
    tagTemplate = "v\${version}"
    with(propertyMissing("git") as net.researchgate.release.GitAdapter.GitConfig) {
        requireBranch = "release/0_2"
    }
}
