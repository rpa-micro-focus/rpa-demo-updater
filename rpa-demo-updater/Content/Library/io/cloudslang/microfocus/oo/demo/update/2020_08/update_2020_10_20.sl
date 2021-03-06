########################################################################################################################
#!!
#! @input log_message: Update from 2020/10/20
#! @input github_repos: Which CPs to be downloaded into Central; given in the dependencies order (so newly added content has its dependencies already loaded)
#! @input usernames: Which workspaces to be updated
#! @input cp_folder: Where to download he CPs
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.oo.demo.update.2020_08
flow:
  name: update_2020_10_20
  inputs:
    - log_message:
        default: update 2020/10/20 - Update CPs; update workspaces; generate ROI
        private: false
    - github_repos: 'rpa-micro-focus/cs-base-te-addon,rpa-micro-focus/rpa-rpa,rpa-micro-focus/rpa-demo,rpa-micro-focus/rpa-microsoft-graph,rpa-micro-focus/cs-microfocus-enterprise-server,pe-pan/rpa-aos,pe-pan/rpa-sap,pe-pan/rpa-salesforce'
    - usernames: 'aosdev,sapdev,sfdev,admin,rpadev,rpademo,rpaqa,addondev,addonqa,esdev'
    - cp_folder: "C:\\\\Users\\\\Administrator\\\\Downloads\\\\demo-content-packs"
  workflow:
    - update_cp_from_github:
        loop:
          for: github_repo in github_repos
          do:
            io.cloudslang.microfocus.oo.central.content-pack.update_cp_from_github:
              - github_repo: '${github_repo}'
              - cp_folder: '${cp_folder}'
          break: []
          publish:
            - failure: ''
        navigate:
          - FAILURE: log_update_cp_error
          - NOTHING_TO_UPDATE: execute_update_workspace
          - ALREADY_DEPLOYED: execute_update_workspace
          - SUCCESS: execute_update_workspace
    - execute_update_workspace:
        loop:
          for: username in usernames
          do:
            io.cloudslang.microfocus.oo.central.execution.execute_flow:
              - flow_uuid: io.cloudslang.microfocus.oo.demo.sub_flows.update_workspace
              - flow_run_name: "${'update workspace of '+username}"
              - flow_inputs: "${'{\"username\": \"%s\"}' % username}"
          break: []
        navigate:
          - SUCCESS: execute_generate_roi_numbers
          - FAILURE_TIMED_OUT: log_update_ws_error
          - FAILURE_UNCOMPLETED: log_update_ws_error
          - FAILURE: log_update_ws_error
    - execute_generate_roi_numbers:
        do:
          io.cloudslang.microfocus.oo.central.execution.trigger_flow:
            - flow_uuid: io.cloudslang.microfocus.oo.demo.generate_roi_numbers
            - flow_inputs: |-
                ${'''
                {
                  "num_of_occurences_range": "1-10",
                  "roi_range": "5-20"
                }
                '''}
        navigate:
          - FAILURE: log_generate_roi_error
          - SUCCESS: has_any_failure
    - log_update_cp_error:
        do:
          io.cloudslang.base.utils.do_nothing:
            - failure_in: '${failure}'
        publish:
          - failure: CP update has failed
        navigate:
          - SUCCESS: execute_update_workspace
          - FAILURE: on_failure
    - log_update_ws_error:
        do:
          io.cloudslang.base.utils.do_nothing:
            - failure_in: '${failure}'
        publish:
          - failure: "${('' if failure_in == '' else failure_in+',')+'Workspace update has failed'}"
        navigate:
          - SUCCESS: execute_generate_roi_numbers
          - FAILURE: on_failure
    - log_generate_roi_error:
        do:
          io.cloudslang.base.utils.do_nothing:
            - failure_in: '${failure}'
        publish:
          - failure: "${('' if failure_in == '' else failure_in+',')+'Generate ROI numbers has failed'}"
        navigate:
          - SUCCESS: has_any_failure
          - FAILURE: on_failure
    - has_any_failure:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(len(failure)>0)}'
        navigate:
          - 'TRUE': FAILURE
          - 'FALSE': SUCCESS
  outputs:
    - failure: '${failure}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      update_cp_from_github:
        x: 46
        'y': 90
      execute_update_workspace:
        x: 309
        'y': 96
      execute_generate_roi_numbers:
        x: 552
        'y': 98
      log_update_cp_error:
        x: 44
        'y': 317
      log_update_ws_error:
        x: 306
        'y': 315
      log_generate_roi_error:
        x: 550
        'y': 318
      has_any_failure:
        x: 713
        'y': 204
        navigate:
          4a8f6a8a-157a-b4a3-d442-e2696397792e:
            targetId: 2a67f5a2-e0bd-8258-60aa-93c237a78fc8
            port: 'TRUE'
          fdc80666-54fc-ac30-633d-397dc07ee3b2:
            targetId: bf9dd3ec-0a3b-0479-c2a4-0ab2df756ea7
            port: 'FALSE'
    results:
      FAILURE:
        2a67f5a2-e0bd-8258-60aa-93c237a78fc8:
          x: 855
          'y': 313
      SUCCESS:
        bf9dd3ec-0a3b-0479-c2a4-0ab2df756ea7:
          x: 853
          'y': 91
