namespace: io.cloudslang.microfocus.demo.rpa.update
flow:
  name: update_rpa_demo
  workflow:
    - write_to_file:
        do:
          io.cloudslang.base.filesystem.write_to_file:
            - file_path: "c:\\\\temp\\\\test.txt"
            - text: First update
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      write_to_file:
        x: 68
        'y': 102
        navigate:
          ae32358b-288c-b1f0-0ea3-da4dceceb993:
            targetId: bdeaacf6-c6bc-a4ac-c318-b091fcd6cbb3
            port: SUCCESS
    results:
      SUCCESS:
        bdeaacf6-c6bc-a4ac-c318-b091fcd6cbb3:
          x: 252
          'y': 102
