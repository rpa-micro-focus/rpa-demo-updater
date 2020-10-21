########################################################################################################################
#!!
#! @description: Downloads cs-microfocus-rpa CP and proceeds with the RPA demo environment update. This updated CP is essential for the update engine to work.
#!               TODO: Replace this flow with io.cloudslang.microfocus.rpa.demo.update._operations.update_rpa_demo_carry_on once cs-microfocus-rpa:1.1.2 is part of Central (flow_run_id is given by execute_flow).
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.demo.update
flow:
  name: update_rpa_demo
  workflow:
    - update_cp_from_github:
        do:
          io.cloudslang.microfocus.rpa.central.content-pack.update_cp_from_github:
            - github_repo: rpa-micro-focus/rpa-rpa
        publish: []
        navigate:
          - FAILURE: on_failure
          - NOTHING_TO_UPDATE: trigger_flow
          - ALREADY_DEPLOYED: trigger_flow
          - SUCCESS: trigger_flow
    - trigger_flow:
        do:
          io.cloudslang.microfocus.rpa.central.execution.trigger_flow:
            - flow_uuid: io.cloudslang.microfocus.rpa.demo.update._operations.update_rpa_demo_carry_on
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      trigger_flow:
        x: 336
        'y': 75
        navigate:
          633ec7d8-b935-d2e5-ef8f-a539f78840d1:
            targetId: a571d925-b136-c842-5495-3ffbb8f3af8c
            port: SUCCESS
      update_cp_from_github:
        x: 79
        'y': 80
    results:
      SUCCESS:
        a571d925-b136-c842-5495-3ffbb8f3af8c:
          x: 530
          'y': 78
