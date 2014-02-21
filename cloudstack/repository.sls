# Install and enable the CloudStack package repository

cloudstack_repo:
  pkgrepo.managed:
    {{ cloudstack.repo_settings | json }}
