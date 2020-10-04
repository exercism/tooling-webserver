import jester
import os
import osproc
import strformat
import strutils
import json
import uuids
import system/ansi_c

type SignalHandler = proc (sign: cint) {.noconv.}

const NimblePkgVersion {.strdefine.}: string = "unknown"

echo fmt"Exercism Local Tooling Webhook v{NimblePkgVersion}"

router routes:
  post "/job":
    # Uniq ID for this job
    let job_id = $(genUUID())

    # Create dirs
    let job_dir = fmt"/tmp/jobs/{job_id}"
    let input_dir = fmt"{job_dir}/input/"
    let output_dir = fmt"{job_dir}/output/"
    os.createDir(input_dir)
    os.createDir(output_dir)

    # Setup input
    let zip_file = fmt"{job_dir}/files.zip"
    let zip_data = request.params["zipped_files"]
    writeFile(zip_file, zip_data)
    discard execShellCmd fmt"unzip {zip_file} -d {input_dir}"
    echo execProcess(fmt"ls -lah {input_dir}")

    # Run command
    let exercise_name = request.params["exercise"]
    let cmd = fmt"./bin/run.sh {exercise_name} {input_dir} {output_dir}"
    setCurrentDir(request.params["working_directory"])
    let exit_status = execShellCmd(cmd)

    let response = %*
        {
            "exit_status": exit_status,
            "output_files": %*{}
        }

    for output_filepath in request.params["output_filepaths"].split(','):
      if fileExists(fmt"{output_dir}/{output_filepath}"):
        response["output_files"][output_filepath] = % readFile(fmt"{output_dir}/{output_filepath}")

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
