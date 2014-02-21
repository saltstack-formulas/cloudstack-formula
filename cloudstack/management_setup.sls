# Configure a new CloudStack management server

include:
  - cloudstack.management
  - mysql.server
  - cloudstack.setup
  - mysql.server
  - ntp
  - openjdk
  - tomcat

extend:
  cloudstack_management:
    pkg:
      - refresh: True

cloudstack_setup_databases:
  cmd:
    - watch
    - name: |
        cloudstack-setup-databases \
            cloud:{{ salt['pillar.get']('cloudstack.management.db_user') }}@localhost \
            --deploy-as=root:{{ salt['pillar.get']('cloudstack.management.db_pass') }} \
            -e {{ salt['pillar.get']('cloudstack.management.encryption_type') }} \
            -m {{ salt['pillar.get']('cloudstack.management.server_key') }} \
            -k {{ salt['pillar.get']('cloudstack.management.database_key') }} \
            -i {{ salt['pillar.get']('cloudstack.management.server_ip') }}
        cloudstack-setup-management
    - require:
      - pkg: mysql_server
    - watch_in:
      - pkg: cloudstack_management
