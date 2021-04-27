########################################################################################################################
#!!
#! @description: RPA demo environment update from May/28/2020; 
#!               - delete an unnecessary file in C:\Temp folder
#!               - generates ROI numbers
#!
#! @input log_message: Update from 2020/05/28
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.oo.demo.update.2020_02
flow:
  name: update_2020_05_08
  inputs:
    - log_message:
        default: update 2020/05/28 - Generate ROI
        private: false
    - file_to_remove:
        default: "C:\\\\Temp\\\\test.txt"
        private: true
  workflow:
    - delete:
        do:
          io.cloudslang.base.filesystem.delete:
            - source: '${file_to_remove}'
        navigate:
          - SUCCESS: generate_roi_numbers
          - FAILURE: generate_roi_numbers
    - generate_roi_numbers:
        do:
          io.cloudslang.microfocus.oo.demo.generate_roi_numbers:
            - num_of_occurences_range: 1-10
            - roi_range: 5-20
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      delete:
        x: 95
        'y': 105
      generate_roi_numbers:
        x: 262
        'y': 97
        navigate:
          ef6279fb-3170-2d5e-a96f-a787c73a41fb:
            targetId: 79608db5-aba1-2f61-327d-20dae2bbf17a
            port: SUCCESS
    results:
      SUCCESS:
        79608db5-aba1-2f61-327d-20dae2bbf17a:
          x: 433
          'y': 97
