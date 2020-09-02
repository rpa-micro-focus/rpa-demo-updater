########################################################################################################################
#!!
#! @description: Downloads and trigger code from GitHub repo that is supposed to update the demo environment. It downloads the latest release of the given GitHub repo.
#!               TODO:
#!                 - remove the temp folder once CP deployed
#!                 - move this implementation to RPA CP
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
    - updater_flow: io.cloudslang.microfocus.demo.rpa.update.update_rpa_demo
    - trigger_expression: '*/120000'
  workflow:
    - get_repo_details:
        do:
          io.cloudslang.base.github.get_repo_details:
            - owner: '${github_repo.split("/")[0]}'
            - repo: '${github_repo.split("/")[1]}'
        publish:
          - release_binary_url
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_temp_file
          - NO_RELEASE: FAILURE
    - download_update:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: '${release_binary_url}'
            - auth_type: anonymous
            - destination_file: '${file_path}'
            - content_type: application/octet-stream
            - method: GET
        navigate:
          - SUCCESS: import_cp
          - FAILURE: on_failure
    - get_temp_file:
        do:
          io.cloudslang.base.filesystem.temp.get_temp_file:
            - file_name: '${release_binary_url.split("/")[-1]}'
        publish:
          - folder_path
          - file_path
        navigate:
          - SUCCESS: download_update
    - import_cp:
        do:
          io.cloudslang.microfocus.rpa.central.content-pack.import_cp:
            - cp_file: '${file_path}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_time
    - schedule_flow:
        do:
          io.cloudslang.microfocus.rpa.central.scheduler.schedule_flow:
            - name: Updating Demo Content
            - uuid: '${updater_flow}'
            - trigger_expression: '${trigger_expression}'
            - start_date: '${time_now}'
            - inputs: ''
            - num_of_occurences: '1'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - get_time:
        do:
          io.cloudslang.base.datetime.get_time:
            - date_format: "${'''yyyy-MM-dd'T'hh:mm:ss'''}"
            - future_minutes: null
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
      get_repo_details:
        x: 53
        'y': 101
        navigate:
          0aec0ca4-5e41-a5c6-d452-5cbda18b43d0:
            targetId: eb658742-0bca-358f-e12d-9f97d209a3bd
            port: NO_RELEASE
      download_update:
        x: 243
        'y': 318
      get_temp_file:
        x: 54
        'y': 321
      import_cp:
        x: 416
        'y': 318
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
          x: 237
          'y': 101
