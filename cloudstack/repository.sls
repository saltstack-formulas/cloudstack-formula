# Install and enable the CloudStack package repository

cloudstack_repo:
  pkgrepo:
    - managed
    - name: {{ cloudstack.repo_url }}
    - keyserver: {{ cloudstack.repo_keyserver }}
    - key_url: {{ cloudstack.repo_pubkey }}

