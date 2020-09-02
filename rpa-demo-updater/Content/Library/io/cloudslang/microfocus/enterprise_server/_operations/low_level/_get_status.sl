namespace: io.cloudslang.microfocus.enterprise_server._operations.low_level
flow:
  name: _get_status
  inputs:
    - url: 'http://rpa.mf-te.com:86/'
  workflow:
    - http_client_get:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: '${url}'
        publish:
          - return_code
          - csrf_token: "${'' if return_code == '-1' else return_result.split('<input type=\"hidden\" name=\"CSRFtk\" value=')[1].split('>')[0].strip()}"
          - es_status: "${'' if return_code == '-1' else return_result.split(\"SIZE=1 COLOR\")[1].split(\">\")[1].splitlines()[0].strip().lower()}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - csrf_token: '${csrf_token}'
    - es_status: '${es_status}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      http_client_get:
        x: 94
        'y': 110
        navigate:
          c3ccd6bc-84a5-6c6f-5734-df56be0228c0:
            targetId: e2db9187-55c7-420a-b43f-938ddf95bf99
            port: SUCCESS
    results:
      SUCCESS:
        e2db9187-55c7-420a-b43f-938ddf95bf99:
          x: 293
          'y': 119
