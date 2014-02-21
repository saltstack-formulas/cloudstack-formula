# Install and configure a CloudStack hypervisor system

{% from "cloudstack/map.jinja" import cloudstack with context %}

include:
  - cloudstack.repository
  - cloudstack.hypervisor_storage
  - libvirt

cloudstack_hypervisor_nfs:
  mount:
    - mounted
    - name: {{ salt['pillar.get']('cloudstack:storage:secondary_mount_point', '/mnt/export/secondary') }}
    - device: {{ salt['pillar.get']('cloudstack:storage:secondary_mount_device', '192.168.38.100:/export/secondary') }}
    - fstype: {{ salt['pillar.get']('cloudstack:storage:secondary_mount_fstype', 'nfs') }}
    - mkmnt: True

cloudstack_agent:
  pkg:
    - installed
    - name: {{ cloudstack.agent_pkg }}
    - require:
      - pkgrepo: cloudstack_repo

cloudstack_libvirt_conf:
  file:
    - managed
    - name: /etc/libvirt/libvirt.conf
    - contents: |
        listen_tls = 0
        listen_tcp = 1
        tcp_port = "16509"
        auth_tcp = "none"
        mdns_adv = 0
    - watch_in:
      - service: libvirt

cloudstack_libvirt_qemu_conf:
  file:
    - managed
    - name: /etc/libvirt/qemu.conf
    - contents: |
        vnc_listen=0.0.0.0
    - watch_in:
      - service: libvirt

cloudstack_libvirt_init_conf:
  file:
    - append
    - name: /etc/init/libvirt-bin.conf
    - text: |
        env libvirtd_opts="-d -l"
    - watch_in:
      - service: libvirt

# ufw allow proto tcp from any to any port 22
# ufw allow proto tcp from any to any port 1798
# ufw allow proto tcp from any to any port 16509
# ufw allow proto tcp from any to any port 5900:6100
# ufw allow proto tcp from any to any port 49152:49216
# ufw enable
