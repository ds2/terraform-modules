plugins {
    id("org.ysb33r.terraform.base") version "0.9.0"
}

terraformSourceSets {
    development 
    staging {
        srcDir = 'tests/aws' 
    }
}
