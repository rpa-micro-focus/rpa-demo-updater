########################################################################################################################
#!!
#! @description: Updates the RPA demo environment; this is the list of updates:
#!                 - 2020/05/28: Generate ROI numbers
#!               
#!
#! @input log_file: File keeping update log
#! @input update_2020_05_28: Update from 2020/05/28
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
    - add_text_to_file:
        do:
          io.cloudslang.base.filesystem.add_text_to_file:
            - file_path: "C:\\\\Enablement\\\\updates.log"
            - text: "${\"%s applied %s\\n\" % (time_now, update_2020_05_28)}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - 2020_05_28_applied:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(update_2020_05_28 in read_text.splitlines()[-1])}'
        navigate:
          - 'TRUE': ALREADY_UP_TO_DATE
          - 'FALSE': update_2020_05_08
    - get_time:
        do:
          io.cloudslang.base.datetime.get_time:
            - date_format: 'dd-MM-yyyy HH:mm:ss'
        publish:
          - time_now: '${output}'
        navigate:
          - SUCCESS: add_text_to_file
          - FAILURE: on_failure
    - update_2020_05_08:
        do:
          io.cloudslang.microfocus.demo.rpa.update.update_2020_05_08: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_time
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
      add_text_to_file:
        x: 558
        'y': 423
        navigate:
          72d7bac6-21d4-1dd9-2419-884a9d04721e:
            targetId: bdeaacf6-c6bc-a4ac-c318-b091fcd6cbb3
            port: SUCCESS
      get_time:
        x: 560
        'y': 243
      update_2020_05_08:
        x: 367
        'y': 239
      2020_05_28_applied:
        x: 126
        'y': 239
        navigate:
          3f960e19-eabc-84aa-a41a-e36658838c76:
            targetId: 2f71a0b0-7ac2-8f69-c93b-4faae0d12ad5
            port: 'TRUE'
    results:
      SUCCESS:
        bdeaacf6-c6bc-a4ac-c318-b091fcd6cbb3:
          x: 555
          'y': 598
      ALREADY_UP_TO_DATE:
        2f71a0b0-7ac2-8f69-c93b-4faae0d12ad5:
          x: 122
          'y': 453
