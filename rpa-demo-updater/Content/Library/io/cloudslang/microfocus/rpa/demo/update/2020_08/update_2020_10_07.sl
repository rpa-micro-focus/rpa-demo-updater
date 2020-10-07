########################################################################################################################
#!!
#! @description: RPA demo environment update from October/07/2020; 
#!                 - copies /etc/hosts file from RPA VM to ROBOT1 VM
#!                 - updates the CPs
#!                 - updates the workspaces
#!                 - generates ROI
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.demo.update.2020_08
flow:
  name: update_2020_10_07
  inputs:
    - content: "${'''\nnet use \\\\\\\\robot1\\C$ \"go.MF.admin123!\" \"/user:robot1\\\\administrator\"\nxcopy /Y c:\\\\Windows\\\\System32\\\\drivers\\\\etc\\\\hosts \\\\\\\\robot1\\\\c$\\\\Windows\\\\System32\\\\drivers\\\\etc\\\\hosts\n'''}"
  workflow:
    - copy_etc_hosts_file:
        do:
          io.cloudslang.microfocus.rpa.demo.update._operations.run_batch_file:
            - content: '${content}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: update_rpa_demo_instance
    - update_rpa_demo_instance:
        do:
          io.cloudslang.microfocus.rpa.demo.update_rpa_demo_instance:
            - github_repos: 'rpa-micro-focus/rpa-microsoft-graph,rpa-micro-focus/cs-base-te-addon,rpa-micro-focus/rpa-demo,rpa-micro-focus/rpa-demo-updater,rpa-micro-focus/cs-microfocus-enterprise-server'
            - usernames: 'admin,rpademo,rpaqa,addondev,addonqa,esdev'
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
      copy_etc_hosts_file:
        x: 51
        'y': 95
    results:
      SUCCESS:
        5ec94771-0281-4420-7328-bb5f699717d9:
          x: 393
          'y': 97
