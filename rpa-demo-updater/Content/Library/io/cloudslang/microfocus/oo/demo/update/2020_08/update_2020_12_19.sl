########################################################################################################################
#!!
#! @input log_message: Update from 2020/12/19
#! @input category_id: Scenario category ID
#! @input scenario_id: Salesforce scenario ID
#! @input scenario_json: JSON document describing Salesforce SSX scenario
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.oo.demo.update.2020_08
flow:
  name: update_2020_12_19
  inputs:
    - log_message: 'update 2020/12/19 - Update Salesforce SSX scenario; flow moved from Salesforce.Order_flow -> Salesforce.order'
    - category_id: '5'
    - scenario_id: '5'
    - scenario_json: |-
        ${'''
            {
              "name": "CREATE AN ORDER",
              "description": "Creates an order in Salesforce",
              "inputs": [
                {
                  "label": "username",
                  "originalName": "username",
                  "type": "STRING",
                  "required": true,
                  "exposed": true,
                  "hasDefaultValue": false,
                  "defaultValue": null,
                  "sources": null,
                  "separator": null
                },
                {
                  "label": "password",
                  "originalName": "password",
                  "type": "CREDENTIAL",
                  "required": true,
                  "exposed": true,
                  "hasDefaultValue": false,
                  "defaultValue": null,
                  "sources": null,
                  "separator": null
                },
                {
                  "label": "account_name",
                  "originalName": "account_name",
                  "type": "STRING",
                  "required": true,
                  "exposed": true,
                  "hasDefaultValue": false,
                  "defaultValue": null,
                  "sources": null,
                  "separator": null
                },
                {
                  "label": "order_date",
                  "originalName": "order_date",
                  "type": "STRING",
                  "required": true,
                  "exposed": true,
                  "hasDefaultValue": false,
                  "defaultValue": null,
                  "sources": null,
                  "separator": null
                },
                {
                  "label": "contract_number",
                  "originalName": "contract_number",
                  "type": "STRING",
                  "required": true,
                  "exposed": true,
                  "hasDefaultValue": false,
                  "defaultValue": null,
                  "sources": null,
                  "separator": null
                },
                {
                  "label": "description",
                  "originalName": "description",
                  "type": "STRING",
                  "required": true,
                  "exposed": true,
                  "hasDefaultValue": false,
                  "defaultValue": null,
                  "sources": null,
                  "separator": null
                }
              ],
              "outputs": [
                {
                  "label": "order_number",
                  "originalName": "order_number",
                  "exposed": true
                },
                {
                  "label": "return_result",
                  "originalName": "return_result",
                  "exposed": true
                },
                {
                  "label": "error_message",
                  "originalName": "error_message",
                  "exposed": true
                }
              ],
              "roles": [
                "ADMINISTRATOR",
                "PROMOTER"
              ],
              "flowVo": {
                "flowUuid": "Salesforce.order",
                "persistenceLevel": "STANDARD",
                "timeoutValue": 0,
                "flowPath": "Library/Salesforce/order.sl"
              }
            }
        '''}
  workflow:
    - get_token:
        do:
          io.cloudslang.microfocus.oo.ssx.authenticate.get_token: []
        publish:
          - token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: update_scenario
    - update_scenario:
        do:
          io.cloudslang.microfocus.oo.ssx.scenario.update_scenario:
            - token: '${token}'
            - scenario_id: '${scenario_id}'
            - category_id: '${category_id}'
            - scenario_json: '${scenario_json}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      update_scenario:
        x: 216
        'y': 109
        navigate:
          685f46f3-9bf7-3264-d126-6e4d7e1fcae8:
            targetId: 187e82ed-d551-23b6-0162-027c64df6ca8
            port: SUCCESS
      get_token:
        x: 41
        'y': 110
    results:
      SUCCESS:
        187e82ed-d551-23b6-0162-027c64df6ca8:
          x: 389
          'y': 111
