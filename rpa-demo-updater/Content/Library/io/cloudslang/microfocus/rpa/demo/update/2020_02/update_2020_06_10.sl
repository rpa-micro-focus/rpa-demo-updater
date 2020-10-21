########################################################################################################################
#!!
#! @description: RPA demo environment update from June/10/2020:
#!               - fixes MF Enterprise Server service
#!               - stops MF Enterprise Server service
#!
#! @input log_message: Update from 2020/06/10
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.demo.update.2020_02
flow:
  name: update_2020_06_10
  inputs:
    - log_message:
        default: update 2020/06/10 - Fix MF Enterprise Server service
        private: false
    - service_url: 'http://rpa.mf-te.com:86/'
    - service_name: mf_CCITCP2
  workflow:
    - fix_service:
        do:
          io.cloudslang.microfocus.enterprise_server.fix_service:
            - url: '${service_url}'
            - service_name: '${service_name}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: stop_service
    - stop_service:
        do:
          io.cloudslang.microfocus.enterprise_server.stop_service:
            - url: '${service_url}'
            - force: 'false'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      fix_service:
        x: 87
        'y': 126
      stop_service:
        x: 269
        'y': 131
        navigate:
          7e846c30-e3a8-3d97-4c44-9811ad6be697:
            targetId: e038b3db-4d77-7655-7437-06f35c0f9756
            port: SUCCESS
    results:
      SUCCESS:
        e038b3db-4d77-7655-7437-06f35c0f9756:
          x: 475
          'y': 130
