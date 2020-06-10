########################################################################################################################
#!!
#! @description: Updates the RPA demo environment; this is the list of updates:
#!               - 2020/05/28: Generate ROI numbers
#!
#! @input log_file: File keeping update log
#! @input update_2020_05_28: Update from 2020/05/28
#! @input update_2020_06_10: Update from 2020/06/10
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.demo.rpa.update
flow:
  name: update_rpa_demo
  inputs:
    - log_file:
        default: "C:\\\\Enablement\\\\updates.log"
        private: true
    - update_2020_05_28:
        default: update 2020/05/28 - Generate ROI
        private: true
    - update_2020_06_10:
        default: update 2020/06/10 - Fix MF Enterprise Server service
        private: true
  workflow:
    - read_from_file:
        do:
          io.cloudslang.base.filesystem.read_from_file:
            - file_path: '${log_file}'
        publish:
          - read_text
        navigate:
          - SUCCESS: 2020_05_28_applied
          - FAILURE: update_2020_05_08
    - 2020_05_28_applied:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(update_2020_05_28 in read_text)}'
        navigate:
          - 'TRUE': 2020_06_10_applied
          - 'FALSE': update_2020_05_08
    - update_2020_05_08:
        do:
          io.cloudslang.microfocus.demo.rpa.update.update_2020_05_08: []
        navigate:
          - FAILURE: 2020_06_10_applied
          - SUCCESS: log_2020_05_28
    - log_2020_05_28:
        do:
          io.cloudslang.microfocus.demo.rpa.update.operations.log_update:
            - log_file: '${log_file}'
            - update_message: '${update_2020_05_28}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: 2020_06_10_applied
    - 2020_06_10_applied:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(update_2020_06_10 in read_text)}'
        navigate:
          - 'TRUE': ALREADY_UP_TO_DATE
          - 'FALSE': update_2020_06_10
    - update_2020_06_10:
        do:
          io.cloudslang.microfocus.demo.rpa.update.update_2020_06_10: []
        navigate:
          - FAILURE: SUCCESS
          - SUCCESS: log_2020_06_10
    - log_2020_06_10:
        do:
          io.cloudslang.microfocus.demo.rpa.update.operations.log_update:
            - log_file: '${log_file}'
            - update_message: '${update_2020_06_10}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
    - ALREADY_UP_TO_DATE
extensions:
  graph:
    steps:
      read_from_file:
        x: 130
        'y': 54
      update_2020_05_08:
        x: 367
        'y': 239
      log_2020_06_10:
        x: 571
        'y': 419
        navigate:
          89e45c87-90c5-7a34-1ea4-2821743c34d6:
            targetId: bdeaacf6-c6bc-a4ac-c318-b091fcd6cbb3
            port: SUCCESS
      update_2020_06_10:
        x: 364
        'y': 415
        navigate:
          07270fd1-a421-7674-29c9-d57d66a08eb7:
            targetId: bdeaacf6-c6bc-a4ac-c318-b091fcd6cbb3
            port: FAILURE
      2020_06_10_applied:
        x: 127
        'y': 413
        navigate:
          6dda9c74-c215-8a73-94ab-704fcf9d081e:
            targetId: 2f71a0b0-7ac2-8f69-c93b-4faae0d12ad5
            port: 'TRUE'
      log_2020_05_28:
        x: 576
        'y': 245
      2020_05_28_applied:
        x: 126
        'y': 239
    results:
      SUCCESS:
        bdeaacf6-c6bc-a4ac-c318-b091fcd6cbb3:
          x: 571
          'y': 586
      ALREADY_UP_TO_DATE:
        2f71a0b0-7ac2-8f69-c93b-4faae0d12ad5:
          x: 125
          'y': 598
