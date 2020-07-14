########################################################################################################################
#!!
#! @description: Retrieves CP details based on the CP name. It fails if none such CP is found.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.central.rest.content-pack
flow:
  name: get_cp
  inputs:
    - cp_name
  workflow:
    - get_cps:
        do:
          io.cloudslang.microfocus.rpa.central.rest.content-pack.get_cps: []
        publish:
          - cps_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: json_path_query
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${cps_json}'
            - json_path: "${\"$[?(@.name == '%s')]\" % cp_name}"
        publish:
          - cp_json: '${return_result}'
          - cp_pton: '${return_result.replace(":null", ":None")}'
          - cp_version: "${eval(cp_pton)[0]['version']}"
          - cp_id: "${eval(cp_pton)[0]['id']}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - cp_json: '${cp_json}'
    - cp_id: '${cp_id}'
    - cp_version: '${cp_version}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      json_path_query:
        x: 291
        'y': 121
        navigate:
          0cd3767b-b645-8bc2-4594-d8d9316eaf12:
            targetId: a7c5620c-e86b-40fd-7ae4-d33c4d5164df
            port: SUCCESS
      get_cps:
        x: 87
        'y': 124
    results:
      SUCCESS:
        a7c5620c-e86b-40fd-7ae4-d33c4d5164df:
          x: 479
          'y': 116
