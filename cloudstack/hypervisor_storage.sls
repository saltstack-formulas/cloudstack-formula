# Configure and seed an NFS store for the hypervisors
# Requires 5 GB of free space

include:
  - nfs.server

cloudstack_nfs_secondary:
  file:
    - directory
    - name: /export/secondary
    - makedirs: True
    - user: nobody
    - group: nogroup
    - dir_mode: 755

cloudstack_nfs:
  file:
    - append
    - name: /etc/exports
    - text: |
        /export/secondary 192.168.38.*(rw,async,no_root_squash,no_subtree_check)
    - require:
      - pkg: nfs_server
      - file: cloudstack_nfs_secondary

cloudstack_nfs_exports:
  cmd:
    - watch
    - name: exportfs -a
    - watch:
      - file: cloudstack_nfs

cloudstack_seed_vm_templates:
  cmd:
    - watch
    - name: |
        {{ cloudstack.common_dir }}/scripts/storage/secondary/cloud-install-sys-tmplt \
          -m /export/secondary \
          -u http://download.cloud.com/templates/acton/acton-systemvm-02062012.qcow2.bz2 \
          -h kvm
    - watch:
      - file: cloudstack_nfs
