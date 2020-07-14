########################################################################################################################
#!!
#! @description: Retrieves the list of deployed content packs
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.central.rest.content-pack
flow:
  name: get_cps
  workflow:
    - central_http_action:
        do:
          rpa.tools.central_http_action:
            - url: /rest/latest/content-packs
            - method: GET
        publish:
          - cps_json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - cps_json: '${cps_json}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      central_http_action:
        x: 71
        'y': 122
        navigate:
          be4136aa-c412-3ca5-c5c1-cf0360e3f401:
            targetId: 478d5dae-91b3-3d04-6390-981838bf0138
            port: SUCCESS
    results:
      SUCCESS:
        478d5dae-91b3-3d04-6390-981838bf0138:
          x: 277
          'y': 124
