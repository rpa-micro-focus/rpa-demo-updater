########################################################################################################################
#!!
#! @description: Sets the service into wanted state and waits till the service changes to this state. 
#!               The valid states are Start / Stop (case sensitive).
#!
#! @input status: Wanted state: Start / Stop (case sensitive)
#! @input force: Force changing the state? Valid only for stopping and should be true / false
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.enterprise_server._operations
flow:
  name: set_status
  inputs:
    - url
    - csrf_token
    - status
    - force: 'false'
  workflow:
    - _set_status:
        do:
          io.cloudslang.microfocus.enterprise_server._operations.low_level._set_status:
            - url: '${url}'
            - status: '${status}'
            - csrf_token: '${csrf_token}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: _confirm_status
    - has_status_changed:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(es_status[:4] == status.lower()[:4])}'
        navigate:
          - 'TRUE': SUCCESS
          - 'FALSE': shall_retry
    - shall_retry:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(int(retries) > 0)}'
            - retries: '${retries}'
        publish:
          - retries: '${str(int(retries)-1)}'
        navigate:
          - 'TRUE': sleep
          - 'FALSE': FAILURE
    - sleep:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '2'
        navigate:
          - SUCCESS: _get_status
          - FAILURE: on_failure
    - _confirm_status:
        do:
          io.cloudslang.microfocus.enterprise_server._operations.low_level._confirm_status:
            - url: '${url}'
            - csrf_token: '${csrf_token}'
            - status: '${status}'
            - force: '${force}'
        publish:
          - retries: '10'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: _get_status
    - _get_status:
        do:
          io.cloudslang.microfocus.enterprise_server._operations.low_level._get_status:
            - url: '${url}'
        publish:
          - es_status
        navigate:
          - FAILURE: on_failure
          - SUCCESS: has_status_changed
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      _set_status:
        x: 51
        'y': 104
      has_status_changed:
        x: 553
        'y': 291
        navigate:
          e9a20785-8875-b3f3-9461-64d666900daf:
            targetId: 67fe0858-85ff-cfec-1fc3-52594005b5ea
            port: 'TRUE'
      shall_retry:
        x: 552
        'y': 106
        navigate:
          2e3778f8-cc61-895f-e705-214c838c0c54:
            targetId: 28f998d0-426a-136f-cbd1-f6b304162cc1
            port: 'FALSE'
      sleep:
        x: 317
        'y': 103
      _confirm_status:
        x: 49
        'y': 289
      _get_status:
        x: 318
        'y': 291
    results:
      FAILURE:
        28f998d0-426a-136f-cbd1-f6b304162cc1:
          x: 758
          'y': 107
      SUCCESS:
        67fe0858-85ff-cfec-1fc3-52594005b5ea:
          x: 752
          'y': 293
