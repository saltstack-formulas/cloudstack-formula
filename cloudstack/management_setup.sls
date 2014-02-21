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
            cloud:<dbpassword>@localhost \
            --deploy-as=root:<password> \
            -e <encryption_type> \
            -m <management_server_key> \
            -k <database_key> \
            -i <management_server_ip>
        cloudstack-setup-management
    - require:
      - pkg: mysql_server
    - watch_in:
      - pkg: cloudstack_management
