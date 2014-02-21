# Install the CloudStack management server package

{% from "cloudstack/map.jinja" import cloudstack with context %}

include:
  - cloudstack.repository

cloudstack_management:
  pkg:
    - installed
    - name: {{ cloudstack.management_pkg }}
    - require:
      - pkgrepo: cloudstack_repo
  service:
    - running
    - name: {{ cloudstack.management_srv }}
    - enable: True
    - require:
      - pkg: cloudstack_management
