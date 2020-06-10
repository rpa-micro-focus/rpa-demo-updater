namespace: io.cloudslang.microfocus.demo.rpa.update.operations
flow:
  name: log_update
  inputs:
    - log_file: "C:\\\\Enablement\\\\updates.log"
    - update_message
  workflow:
    - get_time:
        do:
          io.cloudslang.base.datetime.get_time:
            - date_format: 'dd-MM-yyyy HH:mm:ss'
        publish:
          - time_now: '${output}'
        navigate:
          - SUCCESS: add_text_to_file
          - FAILURE: on_failure
    - add_text_to_file:
        do:
          io.cloudslang.base.filesystem.add_text_to_file:
            - file_path: '${log_file}'
            - text: "${\"%s applied %s\\n\" % (time_now, update_message)}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_time:
        x: 117
        'y': 99
      add_text_to_file:
        x: 327
        'y': 101
        navigate:
          a37ff4ac-e351-4d49-23b0-955a667f198c:
            targetId: ab473fff-e180-da6a-8e86-fde1424e5bf8
            port: SUCCESS
    results:
      SUCCESS:
        ab473fff-e180-da6a-8e86-fde1424e5bf8:
          x: 515
          'y': 104
