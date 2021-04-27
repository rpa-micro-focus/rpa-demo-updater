########################################################################################################################
#!!
#! @description: Updates the RPA demo environment. It takes the flows from the given folder and applies them in the given order (sorted by names alphabetically). It logs the update application into the given file; the log_message from each update serves as the unique update identification.
#!
#! @input log_file: File keeping update log
#! @input update_folder: Where to take the updates from
#!
#! @output failure: Cause of the failure if the update fails
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.oo.demo.update._operations
flow:
  name: update_rpa_demo_carry_on
  inputs:
    - log_file:
        default: "C:\\\\Enablement\\\\updates.log"
        private: true
    - update_folder: Library/io/cloudslang/microfocus/rpa/demo/update/2020_08
  workflow:
    - read_log_messages:
        do:
          io.cloudslang.base.filesystem.read_from_file:
            - file_path: '${log_file}'
        publish:
          - read_text
        navigate:
          - SUCCESS: get_flows
          - FAILURE: on_failure
    - get_flows:
        do:
          io.cloudslang.microfocus.oo.central.library.get_flows:
            - path: '${update_folder}'
        publish:
          - flows_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_flow_ids
    - get_flow_ids:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${flows_json}'
            - json_path: '$.*.id'
        publish:
          - flow_ids: '${return_result[1:-1]}'
          - failure: ''
          - nothing_applied: 'true'
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
    - list_iterator:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${flow_ids}'
        publish:
          - flow_id: '${result_string[1:-1]}'
        navigate:
          - HAS_MORE: get_flow_inputs
          - NO_MORE: has_any_failure
          - FAILURE: on_failure
    - get_log_message:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${flow_inputs_json}'
            - json_path: "$.[?(@.name == 'log_message')].defaultValue"
        publish:
          - log_message: '${return_result[2:-2]}'
        navigate:
          - SUCCESS: is_update_applied
          - FAILURE: on_failure
    - is_update_applied:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(log_message in read_text)}'
        navigate:
          - 'TRUE': list_iterator
          - 'FALSE': execute_flow
    - execute_flow:
        do:
          io.cloudslang.microfocus.oo.central.execution.execute_flow:
            - flow_uuid: '${flow_id}'
        navigate:
          - SUCCESS: log_update
          - FAILURE_TIMED_OUT: add_failure
          - FAILURE_UNCOMPLETED: add_failure
          - FAILURE: add_failure
    - log_update:
        do:
          io.cloudslang.microfocus.oo.demo.update._operations.log_update:
            - log_file: '${log_file}'
            - update_message: '${log_message}'
        publish:
          - nothing_applied: 'false'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: list_iterator
    - add_failure:
        do:
          io.cloudslang.base.utils.do_nothing:
            - failure_in: '${failure}'
            - flow_id: '${flow_id}'
        publish:
          - failure: "${(\"\" if failure_in == \"\" else failure_in+\",\")+flow_id.split('.')[-1]+\" has failed\"}"
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
    - has_any_failure:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(len(failure)>0)}'
        navigate:
          - 'TRUE': FAILURE
          - 'FALSE': is_nothing_applied
    - is_nothing_applied:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${nothing_applied}'
        navigate:
          - 'TRUE': ALREADY_UP_TO_DATE
          - 'FALSE': SUCCESS
    - get_flow_inputs:
        do:
          io.cloudslang.microfocus.oo.demo.update._operations.get_flow_inputs:
            - flow_uuid: '${flow_id}'
        publish:
          - flow_inputs_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_log_message
  outputs:
    - failure: '${failure}'
  results:
    - FAILURE
    - ALREADY_UP_TO_DATE
    - SUCCESS
extensions:
  graph:
    steps:
      get_log_message:
        x: 506
        'y': 577
      log_update:
        x: 29
        'y': 274
      add_failure:
        x: 154
        'y': 418
      list_iterator:
        x: 277
        'y': 274
      get_flow_ids:
        x: 506
        'y': 71
      read_log_messages:
        x: 35
        'y': 71
      get_flow_inputs:
        x: 505
        'y': 277
      has_any_failure:
        x: 722
        'y': 71
        navigate:
          87073506-1a95-cac3-96f1-cc864bd22f3f:
            targetId: 6b67526c-42eb-1c32-9a49-c54dc0bc19a6
            port: 'TRUE'
      is_nothing_applied:
        x: 717
        'y': 276
        navigate:
          3b7d7178-d4ad-08e9-0f5c-67170cbeb7d1:
            targetId: 2f71a0b0-7ac2-8f69-c93b-4faae0d12ad5
            port: 'TRUE'
          c5c3abd0-b5e3-704f-9f65-952306f44546:
            targetId: a571d925-b136-c842-5495-3ffbb8f3af8c
            port: 'FALSE'
      execute_flow:
        x: 31
        'y': 577
      is_update_applied:
        x: 275
        'y': 577
      get_flows:
        x: 281
        'y': 70
    results:
      FAILURE:
        6b67526c-42eb-1c32-9a49-c54dc0bc19a6:
          x: 923
          'y': 71
      ALREADY_UP_TO_DATE:
        2f71a0b0-7ac2-8f69-c93b-4faae0d12ad5:
          x: 922
          'y': 280
      SUCCESS:
        a571d925-b136-c842-5495-3ffbb8f3af8c:
          x: 716
          'y': 486
