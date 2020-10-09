########################################################################################################################
#!!
#! @description: RPA demo environment update from October/07/2020; 
#!               - updates the CPs
#!               - updates the workspaces
#!               - generates ROI
#!
#! @input github_repos: GitHub repos where to download new CPs from
#! @input usernames: Usernames who workspaces to be updated
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.demo.update.2020_08
flow:
  name: update_2020_10_07
  inputs:
    - github_repos: 'rpa-micro-focus/rpa-microsoft-graph,rpa-micro-focus/cs-base-te-addon,rpa-micro-focus/rpa-demo,rpa-micro-focus/rpa-demo-updater,rpa-micro-focus/cs-microfocus-enterprise-server'
    - usernames: 'admin,rpademo,rpaqa,addondev,addonqa,esdev'
  workflow:
    - update_rpa_demo_instance:
        do:
          io.cloudslang.microfocus.rpa.demo.update_rpa_demo_instance:
            - github_repos: '${github_repos}'
            - usernames: '${usernames}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      update_rpa_demo_instance:
        x: 224
        'y': 94
        navigate:
          24b8126f-c908-65c9-4f86-0c3625597a69:
            targetId: 5ec94771-0281-4420-7328-bb5f699717d9
            port: SUCCESS
    results:
      SUCCESS:
        5ec94771-0281-4420-7328-bb5f699717d9:
          x: 393
          'y': 97
