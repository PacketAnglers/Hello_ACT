# LEAF2

## Table of Contents

- [Management](#management)
  - [Management Interfaces](#management-interfaces)
  - [IP Name Servers](#ip-name-servers)
  - [NTP](#ntp)
  - [Management API HTTP](#management-api-http)
- [Authentication](#authentication)
  - [Local Users](#local-users)
  - [AAA Authorization](#aaa-authorization)
- [Monitoring](#monitoring)
  - [TerminAttr Daemon](#terminattr-daemon)
- [MLAG](#mlag)
  - [MLAG Summary](#mlag-summary)
  - [MLAG Device Configuration](#mlag-device-configuration)
- [Spanning Tree](#spanning-tree)
  - [Spanning Tree Summary](#spanning-tree-summary)
  - [Spanning Tree Device Configuration](#spanning-tree-device-configuration)
- [Internal VLAN Allocation Policy](#internal-vlan-allocation-policy)
  - [Internal VLAN Allocation Policy Summary](#internal-vlan-allocation-policy-summary)
  - [Internal VLAN Allocation Policy Device Configuration](#internal-vlan-allocation-policy-device-configuration)
- [VLANs](#vlans)
  - [VLANs Summary](#vlans-summary)
  - [VLANs Device Configuration](#vlans-device-configuration)
- [Interfaces](#interfaces)
  - [Switchport Default](#switchport-default)
  - [Ethernet Interfaces](#ethernet-interfaces)
  - [Port-Channel Interfaces](#port-channel-interfaces)
  - [VLAN Interfaces](#vlan-interfaces)
- [Routing](#routing)
  - [Service Routing Protocols Model](#service-routing-protocols-model)
  - [IP Routing](#ip-routing)
  - [IPv6 Routing](#ipv6-routing)
- [Multicast](#multicast)
  - [IP IGMP Snooping](#ip-igmp-snooping)
- [VRF Instances](#vrf-instances)
  - [VRF Instances Summary](#vrf-instances-summary)
  - [VRF Instances Device Configuration](#vrf-instances-device-configuration)

## Management

### Management Interfaces

#### Management Interfaces Summary

##### IPv4

| Management Interface | Description | Type | VRF | IP Address | Gateway |
| -------------------- | ----------- | ---- | --- | ---------- | ------- |
| Management1 | oob_management | oob | default | 192.168.0.14/24 | - |

##### IPv6

| Management Interface | Description | Type | VRF | IPv6 Address | IPv6 Gateway |
| -------------------- | ----------- | ---- | --- | ------------ | ------------ |
| Management1 | oob_management | oob | default | - | - |

#### Management Interfaces Device Configuration

```eos
!
interface Management1
   description oob_management
   no shutdown
   ip address 192.168.0.14/24
```

### IP Name Servers

#### IP Name Servers Summary

| Name Server | VRF | Priority |
| ----------- | --- | -------- |
| 8.8.8.8 | default | - |

#### IP Name Servers Device Configuration

```eos
ip name-server vrf default 8.8.8.8
```

### NTP

#### NTP Summary

##### NTP Servers

| Server | VRF | Preferred | Burst | iBurst | Version | Min Poll | Max Poll | Local-interface | Key |
| ------ | --- | --------- | ----- | ------ | ------- | -------- | -------- | --------------- | --- |
| time.google.com | - | - | - | True | - | - | - | Management1 | - |

#### NTP Device Configuration

```eos
!
ntp server time.google.com iburst local-interface Management1
```

### Management API HTTP

#### Management API HTTP Summary

| HTTP | HTTPS | Default Services |
| ---- | ----- | ---------------- |
| False | True | - |

#### Management API VRF Access

| VRF Name | IPv4 ACL | IPv6 ACL |
| -------- | -------- | -------- |
| default | - | - |

#### Management API HTTP Device Configuration

```eos
!
management api http-commands
   protocol https
   no shutdown
   !
   vrf default
      no shutdown
```

## Authentication

### Local Users

#### Local Users Summary

| User | Privilege | Role | Disabled | Shell |
| ---- | --------- | ---- | -------- | ----- |
| cvpadmin | 15 | network-admin | False | - |
| service | 15 | network-admin | False | /bin/bash |

#### Local Users Device Configuration

```eos
!
username cvpadmin privilege 15 role network-admin secret sha512 <removed>
username service privilege 15 role network-admin shell /bin/bash secret sha512 <removed>
```

### AAA Authorization

#### AAA Authorization Summary

| Type | User Stores |
| ---- | ----------- |
| Exec | local |

Authorization for configuration commands is disabled.

#### AAA Authorization Device Configuration

```eos
aaa authorization exec default local
!
```

## Monitoring

### TerminAttr Daemon

#### TerminAttr Daemon Summary

| CV Compression | CloudVision Servers | VRF | Authentication | Smash Excludes | Ingest Exclude | Bypass AAA |
| -------------- | ------------------- | --- | -------------- | -------------- | -------------- | ---------- |
| gzip | 192.168.0.5:9910 | - | token,/tmp/token | ale,flexCounter,hardware,kni,pulse,strata | /Sysdb/cell/1/agent,/Sysdb/cell/2/agent | False |

#### TerminAttr Daemon Device Configuration

```eos
!
daemon TerminAttr
   exec /usr/bin/TerminAttr -cvaddr=192.168.0.5:9910 -cvauth=token,/tmp/token -smashexcludes=ale,flexCounter,hardware,kni,pulse,strata -ingestexclude=/Sysdb/cell/1/agent,/Sysdb/cell/2/agent -taillogs
   no shutdown
```

## MLAG

### MLAG Summary

| Domain-id | Local-interface | Peer-address | Peer-link |
| --------- | --------------- | ------------ | --------- |
| POD1 | Vlan4094 | 10.1.253.0 | Port-Channel51 |

Dual primary detection is disabled.

### MLAG Device Configuration

```eos
!
mlag configuration
   domain-id POD1
   local-interface Vlan4094
   peer-address 10.1.253.0
   peer-link Port-Channel51
   reload-delay mlag 300
   reload-delay non-mlag 330
```

## Spanning Tree

### Spanning Tree Summary

STP mode: **rstp**

#### Global Spanning-Tree Settings

- Global RSTP priority: 8192
- Spanning Tree disabled for VLANs: **4094**

### Spanning Tree Device Configuration

```eos
!
spanning-tree mode rstp
no spanning-tree vlan-id 4094
spanning-tree priority 8192
```

## Internal VLAN Allocation Policy

### Internal VLAN Allocation Policy Summary

| Policy Allocation | Range Beginning | Range Ending |
| ------------------| --------------- | ------------ |
| ascending | 1006 | 1199 |

### Internal VLAN Allocation Policy Device Configuration

```eos
!
vlan internal order ascending range 1006 1199
```

## VLANs

### VLANs Summary

| VLAN ID | Name | Trunk Groups |
| ------- | ---- | ------------ |
| 10 | Ten | - |
| 20 | Twenty | - |
| 30 | Thirty | - |
| 40 | Forty | - |
| 4094 | MLAG_PEER | MLAG |

### VLANs Device Configuration

```eos
!
vlan 10
   name Ten
!
vlan 20
   name Twenty
!
vlan 30
   name Thirty
!
vlan 40
   name Forty
!
vlan 4094
   name MLAG_PEER
   trunk group MLAG
```

## Interfaces

### Switchport Default

#### Switchport Defaults Summary

- Default Switchport Mode: routed

#### Switchport Default Device Configuration

```eos
!
switchport default mode routed
```

### Ethernet Interfaces

#### Ethernet Interfaces Summary

##### L2

| Interface | Description | Mode | VLANs | Native VLAN | Trunk Group | Channel-Group |
| --------- | ----------- | ---- | ----- | ----------- | ----------- | ------------- |
| Ethernet49 | SPINE1_Ethernet2 | *trunk | *10,20,30,40 | *- | *- | 49 |
| Ethernet50 | SPINE2_Ethernet2 | *trunk | *10,20,30,40 | *- | *- | 49 |
| Ethernet51 | MLAG_PEER_LEAF1_Ethernet51 | *trunk | *- | *- | *['MLAG'] | 51 |
| Ethernet52 | MLAG_PEER_LEAF1_Ethernet52 | *trunk | *- | *- | *['MLAG'] | 51 |

*Inherited from Port-Channel Interface

#### Ethernet Interfaces Device Configuration

```eos
!
interface Ethernet49
   description SPINE1_Ethernet2
   no shutdown
   channel-group 49 mode active
!
interface Ethernet50
   description SPINE2_Ethernet2
   no shutdown
   channel-group 49 mode active
!
interface Ethernet51
   description MLAG_PEER_LEAF1_Ethernet51
   no shutdown
   channel-group 51 mode active
!
interface Ethernet52
   description MLAG_PEER_LEAF1_Ethernet52
   no shutdown
   channel-group 51 mode active
```

### Port-Channel Interfaces

#### Port-Channel Interfaces Summary

##### L2

| Interface | Description | Type | Mode | VLANs | Native VLAN | Trunk Group | LACP Fallback Timeout | LACP Fallback Mode | MLAG ID | EVPN ESI |
| --------- | ----------- | ---- | ---- | ----- | ----------- | ------------| --------------------- | ------------------ | ------- | -------- |
| Port-Channel49 | SPINES_Po1 | switched | trunk | 10,20,30,40 | - | - | - | - | 49 | - |
| Port-Channel51 | MLAG_PEER_LEAF1_Po51 | switched | trunk | - | - | ['MLAG'] | - | - | - | - |

#### Port-Channel Interfaces Device Configuration

```eos
!
interface Port-Channel49
   description SPINES_Po1
   no shutdown
   switchport
   switchport trunk allowed vlan 10,20,30,40
   switchport mode trunk
   mlag 49
!
interface Port-Channel51
   description MLAG_PEER_LEAF1_Po51
   no shutdown
   switchport
   switchport mode trunk
   switchport trunk group MLAG
```

### VLAN Interfaces

#### VLAN Interfaces Summary

| Interface | Description | VRF |  MTU | Shutdown |
| --------- | ----------- | --- | ---- | -------- |
| Vlan4094 | MLAG_PEER | default | 1500 | False |

##### IPv4

| Interface | VRF | IP Address | IP Address Virtual | IP Router Virtual Address | VRRP | ACL In | ACL Out |
| --------- | --- | ---------- | ------------------ | ------------------------- | ---- | ------ | ------- |
| Vlan4094 |  default  |  10.1.253.1/31  |  -  |  -  |  -  |  -  |  -  |

#### VLAN Interfaces Device Configuration

```eos
!
interface Vlan4094
   description MLAG_PEER
   no shutdown
   mtu 1500
   no autostate
   ip address 10.1.253.1/31
```

## Routing

### Service Routing Protocols Model

Multi agent routing protocol model enabled

```eos
!
service routing protocols model multi-agent
```

### IP Routing

#### IP Routing Summary

| VRF | Routing Enabled |
| --- | --------------- |
| default | False |

#### IP Routing Device Configuration

```eos
```

### IPv6 Routing

#### IPv6 Routing Summary

| VRF | Routing Enabled |
| --- | --------------- |
| default | False |
| default | false |

## Multicast

### IP IGMP Snooping

#### IP IGMP Snooping Summary

| IGMP Snooping | Fast Leave | Interface Restart Query | Proxy | Restart Query Interval | Robustness Variable |
| ------------- | ---------- | ----------------------- | ----- | ---------------------- | ------------------- |
| Enabled | - | - | - | - | - |

#### IP IGMP Snooping Device Configuration

```eos
```

## VRF Instances

### VRF Instances Summary

| VRF Name | IP Routing |
| -------- | ---------- |

### VRF Instances Device Configuration

```eos
```
