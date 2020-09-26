########################################################################################################################
#!!
#! @description: Downloads and triggers code from GitHub repo that is supposed to update the demo environment. It downloads the latest release of the given GitHub repo. 
#!               It also disables the schedule that triggered this flow (so this flow is executed only once).
#!
#! @input github_repo: GitHub repo containing the updater code
#! @input updater_flow: Code to be executed once update downloaded
#! @input disable_schedule: If given, this schedule will be disabled once the updater gets triggered
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.demo.update
flow:
  name: download_latest_update
  inputs:
    - github_repo: rpa-micro-focus/rpa-demo-updater
    - updater_flow: io.cloudslang.microfocus.rpa.demo.update.update_rpa_demo
    - disable_schedule:
        default: download_latest_update
        required: false
  workflow:
    - update_cp_from_github:
        do:
          io.cloudslang.microfocus.rpa.central.content-pack.update_cp_from_github:
            - github_repo: '${github_repo}'
        navigate:
          - FAILURE: on_failure
          - NOTHING_TO_UPDATE: FAILURE
          - ALREADY_DEPLOYED: is_schdl_to_disable
          - SUCCESS: trigger_flow
    - trigger_flow:
        do:
          io.cloudslang.microfocus.rpa.central.execution.trigger_flow:
            - flow_uuid: '${updater_flow}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: is_schdl_to_disable
    - disable_schedule:
        loop:
          for: schedule_id in eval(schedule_ids)
          do:
            io.cloudslang.microfocus.rpa.central.scheduler.enable_schedule:
              - schedule_id: '${schedule_id}'
              - enabled: 'false'
          break:
            - FAILURE
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - filter_schedules:
        do:
          io.cloudslang.microfocus.rpa.central.scheduler.filter_schedules:
            - filter_name: flowScheduleName
            - filter_value: "${\"'%s'\" % disable_schedule}"
        publish:
          - schedule_ids
        navigate:
          - FAILURE: on_failure
          - SUCCESS: no_schedule
    - is_schdl_to_disable:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(len(disable_schedule)>0)}'
        navigate:
          - 'TRUE': filter_schedules
          - 'FALSE': SUCCESS
    - no_schedule:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(schedule_ids == '[]')}"
        navigate:
          - 'TRUE': SUCCESS
          - 'FALSE': disable_schedule
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      update_cp_from_github:
        x: 56
        'y': 189
        navigate:
          140b236b-c2b1-fdac-48d8-b22b317c2228:
            targetId: eb658742-0bca-358f-e12d-9f97d209a3bd
            port: NOTHING_TO_UPDATE
      trigger_flow:
        x: 215
        'y': 16
      disable_schedule:
        x: 827
        'y': 343
        navigate:
          f4e56484-2ddc-43f4-aaf7-dfe5ff03a5a3:
            targetId: 63e311c2-e859-b248-58b9-bf9844eac74e
            port: SUCCESS
      filter_schedules:
        x: 511
        'y': 22
      is_schdl_to_disable:
        x: 360
        'y': 189
        navigate:
          06b05298-33be-8c8f-80f8-af03d8b6ab01:
            targetId: 63e311c2-e859-b248-58b9-bf9844eac74e
            port: 'FALSE'
      no_schedule:
        x: 667
        'y': 187
        navigate:
          41c51aaf-f346-a187-efcc-8773b9a792ef:
            targetId: 63e311c2-e859-b248-58b9-bf9844eac74e
            port: 'TRUE'
    results:
      SUCCESS:
        63e311c2-e859-b248-58b9-bf9844eac74e:
          x: 513
          'y': 341
      FAILURE:
        eb658742-0bca-358f-e12d-9f97d209a3bd:
          x: 220
          'y': 343
