namespace: io.cloudslang.microfocus.enterprise_server._operations.low_level
flow:
  name: _set_status
  inputs:
    - url
    - status
    - csrf_token
  workflow:
    - http_client_post:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: '${url}'
            - body: "${'page=1000&CSRFtk={csrf_token}&mfServerAutoRefreshPeriod=10&mfserverlistmax=10&mfServerTypeFilter=0&mfServerNameFilter=*&mfServerStatusFilter=0&button_{status}_action_server_U1.2.840.5043.01.025.1328810261.1**={status}...'.format(status=status, csrf_token=csrf_token)}"
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
        x: 63
        'y': 97
        navigate:
          afaff747-7b36-86e4-8998-520833e6236f:
            targetId: 0e2ccfec-4308-3019-b8f7-a06fbe348242
            port: SUCCESS
    results:
      SUCCESS:
        0e2ccfec-4308-3019-b8f7-a06fbe348242:
          x: 253
          'y': 101
