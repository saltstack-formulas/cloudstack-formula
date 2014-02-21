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
    # Since we're setting up for the first time, make sure the newly added
    # package repo has been fetched.
    pkg:
      - refresh: True

cloudstack_dbname:
  mysql_database:
    - present
    - name: {{ salt['pillar.get']('cloudstack:management:db_name') }}

cloudstack_dbuser:
  mysql_user:
    - present
    - name:  {{ salt['pillar.get']('cloudstack:management:db_name') }}
    - host: localhost
    - password: {{ salt['pillar.get']('cloudstack:management:db_pass') }}
    - connection_user: {{ salt['pillar.get']('cloudstack:management:conn_user') }}
    - connection_pass: {{ salt['pillar.get']('cloudstack:management:conn_pass') }}
    - connection_charset: utf8

cloudstack_dbperms:
  mysql_grants:
    - present
    - name: cloudstack_dbperms
    - grant: select,insert,update
    - database: {{ salt['pillar.get']('cloudstack:management:db_name') }}.*
    - user: {{ salt['pillar.get']('cloudstack:management:db_user') }}
    - host: localhost

cloudstack_setup_databases:
  cmd:
    - watch
    - name: |
        cloudstack-setup-databases \
            cloud:{{ salt['pillar.get']('cloudstack.management.db_user') }}@localhost \
            --deploy-as=root:{{ salt['pillar.get']('cloudstack:management:db_pass') }} \
            -e {{ salt['pillar.get']('cloudstack:management:encryption_type') }} \
            -m {{ salt['pillar.get']('cloudstack:management:server_key') }} \
            -k {{ salt['pillar.get']('cloudstack:management:database_key') }} \
            -i {{ salt['pillar.get']('cloudstack:management:server_ip') }}
        cloudstack-setup-management
    - require:
      - pkg: mysql_server
    - watch_in:
      - pkg: cloudstack_management
