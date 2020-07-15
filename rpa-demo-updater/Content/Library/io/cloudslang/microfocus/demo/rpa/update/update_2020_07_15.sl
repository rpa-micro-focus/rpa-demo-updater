########################################################################################################################
#!!
#! @description: RPA demo environment update from July/15/2020:
#!               - Downloads newest CPs from GitHub repositories
#!               - Updates users' workspaces
#!                 - Pulls changes from GitHub
#!                 - Updates binaries if present in GitHub
#!
#! @input github_repos: Repositories where to download the newest CPs from and deploy them to Central
#! @input usernames: Usernames whose workspaces to be updated (changes pulled out of GitHub repo; binaries inside of CPs updated if present)
#! @input cp_folder: Downloaded CPs will be stored in this folder
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.demo.rpa.update
flow:
  name: update_2020_07_15
  inputs:
    - github_repos: 'pe-pan/rpa-aos,pe-pan/rpa-sap,pe-pan/rpa-salesforce,pe-pan/rpa-robosoc,rpa-micro-focus/rpa-rpa'
    - usernames: 'aosdev,sapdev,sfdev,rpadev'
    - cp_folder: "C:\\\\Users\\\\Administrator\\\\Downloads\\\\demo-content-packs"
  workflow:
    - update_cp_from_github:
        loop:
          for: github_repo in github_repos
          do:
            io.cloudslang.microfocus.rpa.central.rest.content-pack.update_cp_from_github:
              - github_repo: '${github_repo}'
              - cp_folder: '${cp_folder}'
          break: []
        navigate:
          - FAILURE: list_iterator
          - NOTHING_TO_UPDATE: list_iterator
          - ALREADY_DEPLOYED: list_iterator
          - SUCCESS: list_iterator
    - list_iterator:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${usernames}'
        publish:
          - username: '${result_string}'
        navigate:
          - HAS_MORE: get_time
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - get_time:
        do:
          io.cloudslang.base.datetime.get_time:
            - date_format: "${'''yyyy-MM-dd'T'hh:mm:ss'''}"
            - future_minutes: null
        publish:
          - time_now: '${output}'
        navigate:
          - SUCCESS: schedule_update_workspace_flow
          - FAILURE: on_failure
    - schedule_update_workspace_flow:
        do:
          rpa.central.rest.scheduler.schedule_flow:
            - name: "${'Update workspace of '+ username}"
            - uuid: rpa.designer.rest.workspace.test.test_update_workspace
            - start_date: '${time_now}'
            - inputs: "${'\"username\" : \"%s\"' % username}"
            - num_of_occurences: '1'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: list_iterator
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      update_cp_from_github:
        x: 83
        'y': 113
      list_iterator:
        x: 413
        'y': 117
        navigate:
          3c3bf64e-2e4e-d380-e032-fdc8a48e3be7:
            targetId: e7df2df0-c4b7-b88f-3639-1c7ccb6dafb1
            port: NO_MORE
      get_time:
        x: 550
        'y': 284
      schedule_update_workspace_flow:
        x: 315
        'y': 287
    results:
      SUCCESS:
        e7df2df0-c4b7-b88f-3639-1c7ccb6dafb1:
          x: 709
          'y': 115
