########################################################################################################################
#!!
#! @input status: Start / Stop
#! @input force: true / false
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.enterprise_server._operations.low_level
flow:
  name: _confirm_status
  inputs:
    - url
    - csrf_token
    - status
    - force: 'false'
  workflow:
    - http_client_post:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: '${url}'
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
            - body: "${'page=c%s00&CSRFtk=%s%s%s&button_%s_action_U1.2.840.5043.01.025.1328810261.1**=+OK+&mfmedusasysid=SYSTEM&mfmedusapcredoption=a&mfmedusaecredoption=a' % ('6' if status == 'Stop' else '7', csrf_token, '&mfmedusaclearvalues=on' if status == 'Stop' else '','&mfmedusaforcestop=Y&mfmedusamarkstop=Y' if force == 'true' else '' , status)}"
            - content_type: application/x-www-form-urlencoded
        publish:
          - return_result
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      http_client_post:
        x: 64
        'y': 105
        navigate:
          3d91626b-ada0-f311-7740-457d5db6fa5e:
            targetId: d4b50a80-9a29-93be-a49a-8e6c5037ff68
            port: SUCCESS
    results:
      SUCCESS:
        d4b50a80-9a29-93be-a49a-8e6c5037ff68:
          x: 253
          'y': 106
