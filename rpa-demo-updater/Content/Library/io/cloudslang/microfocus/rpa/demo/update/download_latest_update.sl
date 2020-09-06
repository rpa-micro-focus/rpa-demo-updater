########################################################################################################################
#!!
#! @description: Downloads and trigger code from GitHub repo that is supposed to update the demo environment. It downloads the latest release of the given GitHub repo.
#!               TODO:
#!               - remove the temp folder once CP deployed
#!               - move this implementation to RPA CP
#!
#! @input github_repo: GitHub repo containing the updater code
#! @input updater_flow: Code to be executed once update downloaded
#! @input trigger_expression: When schedule the downloaded update (*/120000 = after two minutes from download)
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.demo.update
flow:
  name: download_latest_update
  inputs:
    - github_repo: rpa-micro-focus/rpa-demo-updater
    - updater_flow: io.cloudslang.microfocus.rpa.demo.update.update_rpa_demo
    - trigger_expression: '*/120000'
  workflow:
    - update_cp_from_github:
        do:
          io.cloudslang.microfocus.rpa.central.content-pack.update_cp_from_github:
            - github_repo: '${github_repo}'
        navigate:
          - FAILURE: on_failure
          - NOTHING_TO_UPDATE: FAILURE
          - ALREADY_DEPLOYED: SUCCESS
          - SUCCESS: get_time
    - schedule_flow:
        do:
          io.cloudslang.microfocus.rpa.central.scheduler.schedule_flow:
            - name: "${updater_flow.split('.')[-1]}"
            - flow_uuid: '${updater_flow}'
            - trigger_expression: '${trigger_expression}'
            - start_date: '${time_now}'
            - num_of_occurences: '1'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - get_time:
        do:
          io.cloudslang.base.datetime.get_time:
            - date_format: "${'''yyyy-MM-dd'T'hh:mm:ss'''}"
        publish:
          - time_now: '${output}'
        navigate:
          - SUCCESS: schedule_flow
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      update_cp_from_github:
        x: 196
        'y': 106
        navigate:
          140b236b-c2b1-fdac-48d8-b22b317c2228:
            targetId: eb658742-0bca-358f-e12d-9f97d209a3bd
            port: NOTHING_TO_UPDATE
          e604eb38-1292-ce58-9ff5-eb21d4fe228c:
            targetId: 63e311c2-e859-b248-58b9-bf9844eac74e
            port: ALREADY_DEPLOYED
      schedule_flow:
        x: 587
        'y': 107
        navigate:
          7ac10a34-ad6a-d21b-d042-ea852ebbc01e:
            targetId: 63e311c2-e859-b248-58b9-bf9844eac74e
            port: SUCCESS
      get_time:
        x: 415
        'y': 105
    results:
      SUCCESS:
        63e311c2-e859-b248-58b9-bf9844eac74e:
          x: 585
          'y': 320
      FAILURE:
        eb658742-0bca-358f-e12d-9f97d209a3bd:
          x: 331
          'y': 317
