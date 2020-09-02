########################################################################################################################
#!!
#! @description: Retrieves service status (started / stopped / not responding).
#!
#! @output es_status: Service status (started / stopped / not responding)
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.enterprise_server._operations
flow:
  name: get_status
  inputs:
    - url
  workflow:
    - _get_status:
        do:
          io.cloudslang.microfocus.enterprise_server._operations.low_level._get_status:
            - url: '${url}'
        publish:
          - csrf_token
          - es_status
        navigate:
          - FAILURE: on_failure
          - SUCCESS: is_service_started
    - is_service_stopped:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(es_status == 'stopped')}"
        navigate:
          - 'TRUE': STOPPED
          - 'FALSE': OTHER
    - is_service_started:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(es_status == 'started')}"
        navigate:
          - 'TRUE': STARTED
          - 'FALSE': is_service_stopped
  outputs:
    - csrf_token: '${csrf_token}'
    - es_status: '${es_status}'
  results:
    - FAILURE
    - STARTED
    - STOPPED
    - OTHER
extensions:
  graph:
    steps:
      _get_status:
        x: 85
        'y': 86
      is_service_stopped:
        x: 273
        'y': 290
        navigate:
          9a129f1c-3f66-dfe8-7cd0-102205df4f3b:
            targetId: d79c02f3-9633-7700-ec77-66d281523aaa
            port: 'TRUE'
          c172908a-9def-5c70-f374-e6f9c2fec9af:
            targetId: d0e920bc-3fcb-922d-55ae-6ef85736008d
            port: 'FALSE'
      is_service_started:
        x: 274
        'y': 89
        navigate:
          7b5ee3f1-57a9-322b-99a5-e642ef93ef01:
            targetId: 85f1e0f3-315d-8f21-14e5-c6788d8ecd22
            port: 'TRUE'
    results:
      STARTED:
        85f1e0f3-315d-8f21-14e5-c6788d8ecd22:
          x: 450
          'y': 86
      STOPPED:
        d79c02f3-9633-7700-ec77-66d281523aaa:
          x: 449
          'y': 296
      OTHER:
        d0e920bc-3fcb-922d-55ae-6ef85736008d:
          x: 81
          'y': 297
