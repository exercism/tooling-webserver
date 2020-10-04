import system/ansi_c
import std/[json, os, osproc, strformat, strutils]
import pkg/[jester, uuids]

type SignalHandler = proc (sign: cint) {.noconv.}

const NimblePkgVersion {.strdefine.}: string = "unknown"

echo fmt"Exercism Local Tooling Webhook v{NimblePkgVersion}"

router routes:
  post "/job":
    # Create unique ID for this job
    let jobId = $(genUUID())

    # Create dirs
    let jobDir = fmt"/tmp/jobs/{jobId}"
    let inputDir = fmt"{jobDir}/input/"
    let outputDir = fmt"{jobDir}/output/"
    createDir(inputDir)
    createDir(outputDir)

    # Setup input
    let zipFile = fmt"{jobDir}/files.zip"
    let zipData = request.params["zipped_files"]
    writeFile(zipFile, zipData)
    discard execShellCmd fmt"unzip {zipFile} -d {inputDir}"
    echo execProcess(fmt"ls -lah {inputDir}")

    # Run command
    let exerciseName = request.params["exercise"]
    let cmd = fmt"./bin/run.sh {exerciseName} {inputDir} {outputDir}"
    setCurrentDir(request.params["working_directory"])
    let exitStatus = execShellCmd(cmd)

    # Construct response
    let response = %*
      {
        "exit_status": exitStatus,
        "output_files": %*{}
      }

    for outputFilepath in request.params["output_filepaths"].split(','):
      if fileExists(fmt"{outputDir}/{outputFilepath}"):
        response["output_files"][outputFilepath] = % readFile(fmt"{outputDir}/{outputFilepath}")

    resp response

proc sigTermHandler(sign: cint) =
  quit 0

proc main() =
  c_signal(SIGTERM, cast[SignalHandler](sigTermHandler))

  let port = Port(4567)
  let settings = newSettings(port = port)
  var jester = initJester(routes, settings = settings)
  jester.serve()

main()
