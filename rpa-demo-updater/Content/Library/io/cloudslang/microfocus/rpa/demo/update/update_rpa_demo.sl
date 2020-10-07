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
#! @input update_2020_10_07: Update from 2020/10/07
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
    - update_2020_10_07:
        default: 'update 2020/10/07 - Copy /etc/hosts file from RPA -> ROBOT1 VM; update CPs; update workspaces; generate ROI'
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
          io.cloudslang.microfocus.rpa.demo.update.2020_02.update_2020_05_08: []
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
          io.cloudslang.microfocus.rpa.demo.update.2020_02.update_2020_06_10: []
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
          io.cloudslang.microfocus.rpa.demo.update.2020_02.update_2020_07_15: []
        navigate:
          - FAILURE: 2020_10_07_applied
          - SUCCESS: log_2020_07_15
    - log_2020_07_15:
        do:
          io.cloudslang.microfocus.rpa.demo.update._operations.log_update:
            - update_message: '${update_2020_07_15}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: 2020_10_07_applied
    - 2020_07_15_applied:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(update_2020_07_15 in read_text)}'
        navigate:
          - 'TRUE': 2020_10_07_applied
          - 'FALSE': update_2020_07_15
    - update_2020_10_07:
        do:
          io.cloudslang.microfocus.rpa.demo.update.2020_08.update_2020_10_07: []
        navigate:
          - SUCCESS: log_2020_10_07
          - FAILURE: SUCCESS
    - 2020_10_07_applied:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(update_2020_10_07 in read_text)}'
        navigate:
          - 'TRUE': ALREADY_UP_TO_DATE
          - 'FALSE': update_2020_10_07
    - log_2020_10_07:
        do:
          io.cloudslang.microfocus.rpa.demo.update._operations.log_update:
            - update_message: '${update_2020_10_07}'
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
      2020_10_07_applied:
        x: 126
        'y': 780
        navigate:
          20a5913c-6d4a-ac36-861a-c8a18bec9eb4:
            targetId: 2f71a0b0-7ac2-8f69-c93b-4faae0d12ad5
            port: 'TRUE'
      read_from_file:
        x: 130
        'y': 54
      update_2020_06_10:
        x: 364
        'y': 415
      update_2020_07_15:
        x: 365
        'y': 593
      log_2020_06_10:
        x: 571
        'y': 419
      2020_06_10_applied:
        x: 127
        'y': 413
      log_2020_07_15:
        x: 573
        'y': 593
      update_2020_05_08:
        x: 367
        'y': 239
      2020_07_15_applied:
        x: 126
        'y': 593
      log_2020_05_28:
        x: 576
        'y': 245
      update_2020_10_07:
        x: 365
        'y': 782
        navigate:
          75545572-416b-9ef0-cd4e-d80eca7208cb:
            targetId: bdeaacf6-c6bc-a4ac-c318-b091fcd6cbb3
            port: FAILURE
      2020_05_28_applied:
        x: 126
        'y': 239
      log_2020_10_07:
        x: 571
        'y': 781
        navigate:
          34489ac1-4237-8747-f41b-5dfd3b67281a:
            targetId: bdeaacf6-c6bc-a4ac-c318-b091fcd6cbb3
            port: SUCCESS
    results:
      SUCCESS:
        bdeaacf6-c6bc-a4ac-c318-b091fcd6cbb3:
          x: 566
          'y': 965
      ALREADY_UP_TO_DATE:
        2f71a0b0-7ac2-8f69-c93b-4faae0d12ad5:
          x: 124
          'y': 978
