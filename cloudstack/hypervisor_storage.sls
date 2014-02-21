# Configure and seed an NFS store for the hypervisors
# Requires 5 GB of free space

include:
  - nfs.server

cloudstack_nfs_secondary:
  file:
    - directory
    - name: {{ salt['pillar.get']('cloudstack:nfs:mount_dir', '/export/secondary') }}
    - makedirs: True
    - user: {{ salt['pillar.get']('cloudstack.nfs:mount_user', 'nobody') }}
    - group: {{ salt['pillar.get']('cloudstack.nfs:mount_group', 'nogroup') }}
    - dir_mode: {{ salt['pillar.get']('cloudstack.nfs:mount_mode', '755') }}

cloudstack_nfs:
  file:
    - append
    - name: {{ cloudstack.exports_file }}
    - text: |
        {{ salt['pillar.get']('cloudstack.nfs.exports_file', '/export/secondary 192.168.38.*(rw,async,no_root_squash,no_subtree_check)') | indent(8) }}
    - require:
      - pkg: nfs_server
      - file: cloudstack_nfs_secondary

cloudstack_nfs_exports:
  cmd:
    - watch
    - name: {{ salt['pillar.get']('cloudstack.nfs.export_cmd', 'exportfs -a') }}
    - watch:
      - file: cloudstack_nfs

cloudstack_seed_vm_templates:
  cmd:
    - watch
    - name: |
        {{ cloudstack.common_dir }}/scripts/storage/secondary/cloud-install-sys-tmplt \
          -m {{ salt['pillar.get']('cloudstack.nfs.mount_dir') }} \
          -u {{ salt['pillar.get']('cloudstack.nfs.vm_template_archive', 'http://download.cloud.com/templates/acton/acton-systemvm-02062012.qcow2.bz2') }} \
          -h kvm
    - watch:
      - file: cloudstack_nfs
