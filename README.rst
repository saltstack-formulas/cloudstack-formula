==========
CloudStack
==========

Formulas to set up and configure CloudStack.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/topics/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``cloudstack.repository``
-------------------------

Install and enable the CloudStack package repository.

``cloudstack.management``
-------------------------

Ensure the CloudStack management server packages are installed and that the
associated service is running and enabled.

``cloudstack.management_setup``
-------------------------------

Run the setup routines to create a CloudStack management server.

``cloudstack.hypervisor``
-------------------------

Install and configure a CloudStack hypervisor system

``cloudstack.hypervisor_storage``
---------------------------------

Configure and seed an NFS store for the hypervisors. Note, requires 5 GB of
disk space for the VM images.
