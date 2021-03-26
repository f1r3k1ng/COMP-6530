#!/usr/bin/python
# Copyright (c) 2018 Red Hat, Inc.
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

from __future__ import absolute_import, division, print_function
__metaclass__ = type

DOCUMENTATION = '''
---
module: nios_srv_record
author: "Blair Rampling (@brampling)"
short_description: Configure Infoblox NIOS SRV records
description:
  - Adds and/or removes instances of SRV record objects from
    Infoblox NIOS servers.  This module manages NIOS C(record:srv) objects
    using the Infoblox WAPI interface over REST.
requirements:
  - infoblox-client
extends_documentation_fragment:
- community.general.nios

options:
  name:
    description:
      - Specifies the fully qualified hostname to add or remove from
        the system
    required: true
    type: str
  view:
    description:
      - Sets the DNS view to associate this a record with.  The DNS
        view must already be configured on the system
    default: default
    aliases:
      - dns_view
    type: str
  port:
    description:
      - Configures the port (0-65535) of this SRV record.
    type: int
  priority:
    description:
      - Configures the priority (0-65535) for this SRV record.
    type: int
  target:
    description:
      - Configures the target FQDN for this SRV record.
    type: str
  weight:
    description:
      - Configures the weight (0-65535) for this SRV record.
    type: int
  ttl:
    description:
      - Configures the TTL to be associated with this host record
    type: int
  extattrs:
    description:
      - Allows for the configuration of Extensible Attributes on the
        instance of the object.  This argument accepts a set of key / value
        pairs for configuration.
    type: dict
  comment:
    description:
      - Configures a text string comment to be associated with the instance
        of this object.  The provided text string will be configured on the
        object instance.
    type: str
  state:
    description:
      - Configures the intended state of the instance of the object on
        the NIOS server.  When this value is set to C(present), the object
        is configured on the device and when this value is set to C(absent)
        the value is removed (if necessary) from the device.
    default: present
    choices:
      - present
      - absent
    type: str
'''

EXAMPLES = '''
- name: Configure an SRV record
  community.general.nios_srv_record:
    name: _sip._tcp.service.ansible.com
    port: 5080
    priority: 10
    target: service1.ansible.com
    weight: 10
    state: present
    provider:
      host: "{{ inventory_hostname_short }}"
      username: admin
      password: admin
  connection: local

- name: Add a comment to an existing SRV record
  community.general.nios_srv_record:
    name: _sip._tcp.service.ansible.com
    port: 5080
    priority: 10
    target: service1.ansible.com
    weight: 10
    comment: this is a test comment
    state: present
    provider:
      host: "{{ inventory_hostname_short }}"
      username: admin
      password: admin
  connection: local

- name: Remove an SRV record from the system
  community.general.nios_srv_record:
    name: _sip._tcp.service.ansible.com
    port: 5080
    priority: 10
    target: service1.ansible.com
    weight: 10
    state: absent
    provider:
      host: "{{ inventory_hostname_short }}"
      username: admin
      password: admin
  connection: local
'''

RETURN = ''' # '''

from ansible.module_utils.basic import AnsibleModule
from ansible_collections.community.general.plugins.module_utils.net_tools.nios.api import WapiModule
from ansible_collections.community.general.plugins.module_utils.net_tools.nios.api import NIOS_SRV_RECORD
from ansible_collections.community.general.plugins.module_utils.net_tools.nios.api import normalize_ib_spec


def main():
    ''' Main entry point for module execution
    '''

    ib_spec = dict(
        name=dict(required=True, ib_req=True),
        view=dict(default='default', aliases=['dns_view'], ib_req=True),

        port=dict(type='int', ib_req=True),
        priority=dict(type='int', ib_req=True),
        target=dict(ib_req=True),
        weight=dict(type='int', ib_req=True),

        ttl=dict(type='int'),

        extattrs=dict(type='dict'),
        comment=dict(),
    )

    argument_spec = dict(
        provider=dict(required=True),
        state=dict(default='present', choices=['present', 'absent'])
    )

    argument_spec.update(normalize_ib_spec(ib_spec))
    argument_spec.update(WapiModule.provider_spec)

    module = AnsibleModule(argument_spec=argument_spec,
                           supports_check_mode=True)

    wapi = WapiModule(module)
    result = wapi.run(NIOS_SRV_RECORD, ib_spec)

    module.exit_json(**result)


if __name__ == '__main__':
    main()