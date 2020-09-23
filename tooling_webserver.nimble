# Package

version       = "0.11.0"
author        = "Josh Goebel"
description   = "Webhook for running Exercism tooling inside Docker in dev mode"
license       = "AGPL3"
srcDir        = "src"
bin           = @["tooling_webserver"]

backend       = "c"

# Dependencies

requires "nim >= 1.2.6"
requires "jester"
requires "uuids"
