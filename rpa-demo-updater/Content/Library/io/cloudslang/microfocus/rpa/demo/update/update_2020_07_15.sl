########################################################################################################################
#!!
#! @description: RPA demo environment update from July/15/2020:
#!               - Downloads newest CPs from GitHub repositories
#!               - Updates users' workspaces
#!               - Pulls changes from GitHub
#!               - Updates binaries if present in GitHub
#!
#! @input github_repos: Repositories where to download the newest CPs from and deploy them to Central
#! @input usernames: Usernames whose workspaces to be updated (changes pulled out of GitHub repo; binaries inside of CPs updated if present)
#! @input cp_folder: Downloaded CPs will be stored in this folder
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.demo.update
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
            io.cloudslang.microfocus.rpa.central.content-pack.update_cp_from_github:
              - github_repo: '${github_repo}'
              - cp_folder: '${cp_folder}'
          break: []
        navigate:
          - FAILURE: update_workspace
          - NOTHING_TO_UPDATE: update_workspace
          - ALREADY_DEPLOYED: update_workspace
          - SUCCESS: update_workspace
    - update_workspace:
        loop:
          for: username in usernames
          do:
            io.cloudslang.microfocus.rpa.demo.sub_flows.update_workspace:
              - username: '${username}'
          break: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      update_cp_from_github:
        x: 83
        'y': 113
      update_workspace:
        x: 417
        'y': 115
        navigate:
          adcba9b7-13a4-d2f3-740b-5cb382ec4cf5:
            targetId: e7df2df0-c4b7-b88f-3639-1c7ccb6dafb1
            port: SUCCESS
    results:
      SUCCESS:
        e7df2df0-c4b7-b88f-3639-1c7ccb6dafb1:
          x: 709
          'y': 115
