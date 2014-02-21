# Install and enable the CloudStack package repository

{% from "cloudstack/map.jinja" import cloudstack with context %}

cloudstack_repo:
  pkgrepo.managed:
    {{ cloudstack.repo_settings | json }}
