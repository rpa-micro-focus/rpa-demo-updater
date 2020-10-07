########################################################################################################################
#!!
#! @description: Creates a script with given content (in TEMP folder) and executes that.
#!
#! @input batch_file_name: Name of the batch file
#! @input content: Content of the batch file
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.demo.update._operations
flow:
  name: run_batch_file
  inputs:
    - batch_file_name:
        default: script.bat
        private: true
    - content:
        private: false
  workflow:
    - get_temp_file:
        do:
          io.cloudslang.base.filesystem.temp.get_temp_file:
            - file_name: '${batch_file_name}'
        publish:
          - folder_path
          - file_path
        navigate:
          - SUCCESS: write_to_file
    - write_to_file:
        do:
          io.cloudslang.base.filesystem.write_to_file:
            - file_path: '${file_path}'
            - text: '${content}'
        navigate:
          - SUCCESS: run_command
          - FAILURE: on_failure
    - run_command:
        do:
          io.cloudslang.base.cmd.run_command:
            - command: '${batch_file_name}'
            - cwd: '${folder_path}'
        navigate:
          - SUCCESS: delete
          - FAILURE: on_failure
    - delete:
        do:
          io.cloudslang.base.filesystem.delete:
            - source: '${folder_path}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      write_to_file:
        x: 177
        'y': 76
      run_command:
        x: 337
        'y': 76
      delete:
        x: 504
        'y': 81
        navigate:
          28110faa-a227-ee80-4730-a955b14a2fab:
            targetId: 5ec94771-0281-4420-7328-bb5f699717d9
            port: SUCCESS
          1268a979-ba64-8361-e901-e00ff2411c6c:
            targetId: 5ec94771-0281-4420-7328-bb5f699717d9
            port: FAILURE
      get_temp_file:
        x: 21
        'y': 75
    results:
      SUCCESS:
        5ec94771-0281-4420-7328-bb5f699717d9:
          x: 701
          'y': 95
