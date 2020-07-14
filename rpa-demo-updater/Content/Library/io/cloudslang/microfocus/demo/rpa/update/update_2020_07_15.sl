namespace: io.cloudslang.microfocus.demo.rpa.update
flow:
  name: update_2020_07_15
  inputs:
    - github_repos: pe-pan/rpa-aos
  workflow:
    - update_cp_from_github:
        loop:
          for: github_repo in github_repos
          do:
            io.cloudslang.microfocus.rpa.central.rest.content-pack.update_cp_from_github:
              - github_repo: '${github_repo}'
          break: []
        navigate:
          - FAILURE: on_failure
          - NOTHING_TO_UPDATE: SUCCESS
          - ALREADY_DEPLOYED: SUCCESS
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      update_cp_from_github:
        x: 99
        'y': 120
        navigate:
          c2b09e1d-95a3-34f4-aa2c-61d427f69249:
            targetId: e7df2df0-c4b7-b88f-3639-1c7ccb6dafb1
            port: NOTHING_TO_UPDATE
          4b9d2269-a17d-5f23-8459-9922fd2e568d:
            targetId: e7df2df0-c4b7-b88f-3639-1c7ccb6dafb1
            port: ALREADY_DEPLOYED
          e3a16179-f862-295d-c19b-80123cae87ef:
            targetId: e7df2df0-c4b7-b88f-3639-1c7ccb6dafb1
            port: SUCCESS
    results:
      SUCCESS:
        e7df2df0-c4b7-b88f-3639-1c7ccb6dafb1:
          x: 368
          'y': 117
