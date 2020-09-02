########################################################################################################################
#!!
#! @description: Updates the RPA demo environment; this is the list of updates:
#!               - 2020/05/28: Generate ROI numbers
#!               - 2020/06/10: Fix MF Enterprise Server service
#!               - 2020/07/15: Update CPs; enable repetitive activity run in AOS
#!
#! @input log_file: File keeping update log
#! @input update_2020_05_28: Update from 2020/05/28
#! @input update_2020_06_10: Update from 2020/06/10
#! @input update_2020_07_15: Update from 2020/07/15
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.demo.update
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
    - update_2020_07_15:
        default: update 2020/07/15 - Update CPs; enable repetitive activity run in AOS
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
          io.cloudslang.microfocus.rpa.demo.update.update_2020_05_08: []
        navigate:
          - FAILURE: 2020_06_10_applied
          - SUCCESS: log_2020_05_28
    - log_2020_05_28:
        do:
          io.cloudslang.microfocus.rpa.demo.update._operations.log_update:
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
          - 'TRUE': 2020_07_15_applied
          - 'FALSE': update_2020_06_10
    - update_2020_06_10:
        do:
          io.cloudslang.microfocus.rpa.demo.update.update_2020_06_10: []
        navigate:
          - FAILURE: 2020_07_15_applied
          - SUCCESS: log_2020_06_10
    - log_2020_06_10:
        do:
          io.cloudslang.microfocus.rpa.demo.update._operations.log_update:
            - log_file: '${log_file}'
            - update_message: '${update_2020_06_10}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: 2020_07_15_applied
    - update_2020_07_15:
        do:
          io.cloudslang.microfocus.rpa.demo.update.update_2020_07_15: []
        navigate:
          - FAILURE: SUCCESS
          - SUCCESS: log_2020_07_15
    - log_2020_07_15:
        do:
          io.cloudslang.microfocus.rpa.demo.update._operations.log_update:
            - update_message: '${update_2020_07_15}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - 2020_07_15_applied:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(update_2020_07_15 in read_text)}'
        navigate:
          - 'TRUE': ALREADY_UP_TO_DATE
          - 'FALSE': update_2020_07_15
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
      update_2020_06_10:
        x: 364
        'y': 415
      log_2020_06_10:
        x: 571
        'y': 419
      2020_06_10_applied:
        x: 127
        'y': 413
      update_2020_07_15:
        x: 365
        'y': 593
        navigate:
          9c59c7da-dc5e-bb96-b11b-2a531dac2d78:
            targetId: bdeaacf6-c6bc-a4ac-c318-b091fcd6cbb3
            port: FAILURE
      update_2020_05_08:
        x: 367
        'y': 239
      log_2020_05_28:
        x: 576
        'y': 245
      log_2020_07_15:
        x: 573
        'y': 583
        navigate:
          dfb3e1f1-1814-19cb-f538-e3bef1a9e014:
            targetId: bdeaacf6-c6bc-a4ac-c318-b091fcd6cbb3
            port: SUCCESS
      2020_07_15_applied:
        x: 126
        'y': 593
        navigate:
          d043e7d3-c507-ce35-2cda-fe130ca50d75:
            targetId: 2f71a0b0-7ac2-8f69-c93b-4faae0d12ad5
            port: 'TRUE'
      2020_05_28_applied:
        x: 126
        'y': 239
    results:
      SUCCESS:
        bdeaacf6-c6bc-a4ac-c318-b091fcd6cbb3:
          x: 570
          'y': 782
      ALREADY_UP_TO_DATE:
        2f71a0b0-7ac2-8f69-c93b-4faae0d12ad5:
          x: 123
          'y': 739
