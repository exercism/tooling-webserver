# Package

version       = "0.6.0"
author        = "Josh Goebel"
description   = "Webhook for running Exercism test runners inside Docker in dev mode"
license       = "AGPL3"
srcDir        = "src"
bin           = @["exercism_local_tooling_webserver"]

backend       = "c"

# Dependencies

requires "nim >= 1.2.6"
requires "jester"
requires "uuids"
