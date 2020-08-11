# Package

version       = "0.1.0"
author        = "Josh Goebel"
description   = "A new awesome nimble package"
license       = "MIT"
srcDir        = "src"
bin           = @["exercism_local_tooling_webserver"]

backend       = "c"

# Dependencies

requires "nim >= 1.2.6"
requires "jester"
requires "uuids"
