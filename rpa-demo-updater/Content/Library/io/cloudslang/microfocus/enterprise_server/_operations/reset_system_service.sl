########################################################################################################################
#!!
#! @description: Stops and starts the Windows service.
#!
#! @input service_name: Windows service name to restart.
#! @input wait_time: How long to wait once service started (do not wait when not given).
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.enterprise_server._operations
flow:
  name: reset_system_service
  inputs:
    - service_name: mf_CCITCP2
    - wait_time:
        required: false
  workflow:
    - stop_service:
        do:
          io.cloudslang.base.cmd.run_command:
            - command: "${'net stop %s' % service_name}"
        navigate:
          - SUCCESS: start_service
          - FAILURE: start_service
    - start_service:
        do:
          io.cloudslang.base.cmd.run_command:
            - command: "${'net start %s' % service_name}"
        navigate:
          - SUCCESS: sleep
          - FAILURE: on_failure
    - sleep:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: "${get('wait_time', '0')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      stop_service:
        x: 79
        'y': 79
      start_service:
        x: 288
        'y': 80
      sleep:
        x: 466
        'y': 82
        navigate:
          d43687d9-fb5b-0a79-d965-54865a29759f:
            targetId: 60ff5f33-e5ce-a7f1-b400-b0b3f63eb046
            port: SUCCESS
    results:
      SUCCESS:
        60ff5f33-e5ce-a7f1-b400-b0b3f63eb046:
          x: 623
          'y': 82
