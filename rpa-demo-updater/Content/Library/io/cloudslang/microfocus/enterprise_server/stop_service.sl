namespace: io.cloudslang.microfocus.enterprise_server
flow:
  name: stop_service
  inputs:
    - url: 'http://rpa.mf-te.com:86/'
    - force: 'false'
  workflow:
    - get_csrf_token:
        do:
          io.cloudslang.microfocus.enterprise_server._operations.low_level._get_status:
            - url: '${url}'
        publish:
          - csrf_token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: set_status
    - set_status:
        do:
          io.cloudslang.microfocus.enterprise_server._operations.set_status:
            - url: '${url}'
            - csrf_token: '${csrf_token}'
            - status: Stop
            - force: '${force}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      set_status:
        x: 275
        'y': 100
        navigate:
          50b1110f-acdd-12f5-3e81-54618f01d00d:
            targetId: 92f90612-b614-33a2-70b3-d4fb1795a8eb
            port: SUCCESS
      get_csrf_token:
        x: 69
        'y': 98
    results:
      SUCCESS:
        92f90612-b614-33a2-70b3-d4fb1795a8eb:
          x: 476
          'y': 100
