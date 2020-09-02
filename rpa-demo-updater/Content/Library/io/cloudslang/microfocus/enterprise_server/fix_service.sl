########################################################################################################################
#!!
#! @description: Fixes the MF Enterprise Server ACCT service in whatever state it is.
#!               If unknown state, it restarts the service or windows system service to get the service into Started state.
#!               Once finished on SUCCESS, the service should be in Start state and running properly.
#!
#! @input url: URL where MF Enterprise Server administration is running
#! @input service_name: MF CCITCP2 windows service name
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.enterprise_server
flow:
  name: fix_service
  inputs:
    - url: 'http://rpa.mf-te.com:86/'
    - service_name: mf_CCITCP2
  workflow:
    - get_status:
        do:
          io.cloudslang.microfocus.enterprise_server._operations.get_status:
            - url: '${url}'
        publish:
          - csrf_token
          - es_status
        navigate:
          - FAILURE: reset_system_service
          - STARTED: SUCCESS
          - STOPPED: set_status_start
          - OTHER: force_status_stop
    - reset_system_service:
        do:
          io.cloudslang.microfocus.enterprise_server._operations.reset_system_service:
            - service_name: '${service_name}'
            - wait_time: '15'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_status_again
    - set_status_start:
        do:
          io.cloudslang.microfocus.enterprise_server._operations.set_status:
            - url: '${url}'
            - csrf_token: '${csrf_token}'
            - status: Start
            - force: 'false'
        navigate:
          - FAILURE: reset_system_service
          - SUCCESS: SUCCESS
    - force_status_stop:
        do:
          io.cloudslang.microfocus.enterprise_server._operations.set_status:
            - url: '${url}'
            - csrf_token: '${csrf_token}'
            - status: Stop
            - force: 'true'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_status
    - get_status_again:
        do:
          io.cloudslang.microfocus.enterprise_server._operations.get_status:
            - url: '${url}'
        navigate:
          - FAILURE: on_failure
          - STARTED: SUCCESS
          - STOPPED: FAILURE
          - OTHER: FAILURE
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_status:
        x: 82
        'y': 75
        navigate:
          b267da1d-f420-abf5-20b7-87b8617c7b6a:
            targetId: 920434d8-bd0a-b972-2e95-cc6a27b2f090
            port: STARTED
      reset_system_service:
        x: 323
        'y': 433
      set_status_start:
        x: 323
        'y': 236
        navigate:
          75336cf3-7552-1720-48da-0fd961c8ae26:
            targetId: 920434d8-bd0a-b972-2e95-cc6a27b2f090
            port: SUCCESS
      get_status_again:
        x: 594
        'y': 436
        navigate:
          4b7d0d66-5561-6668-96dd-3cd9fa4da285:
            targetId: 420d1eb7-af4b-532a-c5ef-54080cfd2423
            port: OTHER
          6c21068e-db20-6c7b-a99f-0672eea5b3d3:
            targetId: 420d1eb7-af4b-532a-c5ef-54080cfd2423
            port: STOPPED
          010ea5bd-1a43-3ee8-5873-e7272e7f8ccd:
            targetId: 920434d8-bd0a-b972-2e95-cc6a27b2f090
            port: STARTED
      force_status_stop:
        x: 87
        'y': 436
    results:
      FAILURE:
        420d1eb7-af4b-532a-c5ef-54080cfd2423:
          x: 867
          'y': 430
      SUCCESS:
        920434d8-bd0a-b972-2e95-cc6a27b2f090:
          x: 591
          'y': 74
