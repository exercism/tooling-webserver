# Package

version       = "0.5.0"
author        = "Josh Goebel"
description   = "Webhook for running Exercism test runners inside Docker in dev mode"
license       = "MIT"
srcDir        = "src"
bin           = @["exercism_local_tooling_webserver"]

backend       = "c"

# Dependencies

requires "nim >= 1.2.6"
requires "jester"
requires "uuids"
