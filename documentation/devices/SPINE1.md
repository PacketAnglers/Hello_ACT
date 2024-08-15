# SPINE1

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
  - [Loopback Interfaces](#loopback-interfaces)
  - [VLAN Interfaces](#vlan-interfaces)
- [Routing](#routing)
  - [Service Routing Protocols Model](#service-routing-protocols-model)
  - [Virtual Router MAC Address](#virtual-router-mac-address)
  - [IP Routing](#ip-routing)
  - [IPv6 Routing](#ipv6-routing)
  - [Router OSPF](#router-ospf)
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
| Management1 | oob_management | oob | default | 192.168.0.11/24 | - |

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
   ip address 192.168.0.11/24
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
| SPINES | Vlan4094 | 10.1.253.1 | Port-Channel1031 |

Dual primary detection is disabled.

### MLAG Device Configuration

```eos
!
mlag configuration
   domain-id SPINES
   local-interface Vlan4094
   peer-address 10.1.253.1
   peer-link Port-Channel1031
   reload-delay mlag 300
   reload-delay non-mlag 330
```

## Spanning Tree

### Spanning Tree Summary

STP mode: **rstp**

#### Global Spanning-Tree Settings

- Global RSTP priority: 4096
- Spanning Tree disabled for VLANs: **4093-4094**

### Spanning Tree Device Configuration

```eos
!
spanning-tree mode rstp
no spanning-tree vlan-id 4093-4094
spanning-tree priority 4096
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
| 4093 | LEAF_PEER_L3 | LEAF_PEER_L3 |
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
vlan 4093
   name LEAF_PEER_L3
   trunk group LEAF_PEER_L3
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
| Ethernet1 | LEAF1_Ethernet49 | *trunk | *10,20,30,40 | *- | *- | 1 |
| Ethernet2 | LEAF2_Ethernet49 | *trunk | *10,20,30,40 | *- | *- | 1 |
| Ethernet3 | LEAF3_Ethernet49 | *trunk | *10,20,30,40 | *- | *- | 3 |
| Ethernet4 | LEAF4_Ethernet49 | *trunk | *10,20,30,40 | *- | *- | 3 |
| Ethernet103/1 | MLAG_PEER_SPINE2_Ethernet103/1 | *trunk | *- | *- | *['LEAF_PEER_L3', 'MLAG'] | 1031 |
| Ethernet104/1 | MLAG_PEER_SPINE2_Ethernet104/1 | *trunk | *- | *- | *['LEAF_PEER_L3', 'MLAG'] | 1031 |

*Inherited from Port-Channel Interface

#### Ethernet Interfaces Device Configuration

```eos
!
interface Ethernet1
   description LEAF1_Ethernet49
   no shutdown
   channel-group 1 mode active
!
interface Ethernet2
   description LEAF2_Ethernet49
   no shutdown
   channel-group 1 mode active
!
interface Ethernet3
   description LEAF3_Ethernet49
   no shutdown
   channel-group 3 mode active
!
interface Ethernet4
   description LEAF4_Ethernet49
   no shutdown
   channel-group 3 mode active
!
interface Ethernet103/1
   description MLAG_PEER_SPINE2_Ethernet103/1
   no shutdown
   channel-group 1031 mode active
!
interface Ethernet104/1
   description MLAG_PEER_SPINE2_Ethernet104/1
   no shutdown
   channel-group 1031 mode active
```

### Port-Channel Interfaces

#### Port-Channel Interfaces Summary

##### L2

| Interface | Description | Type | Mode | VLANs | Native VLAN | Trunk Group | LACP Fallback Timeout | LACP Fallback Mode | MLAG ID | EVPN ESI |
| --------- | ----------- | ---- | ---- | ----- | ----------- | ------------| --------------------- | ------------------ | ------- | -------- |
| Port-Channel1 | POD1_Po49 | switched | trunk | 10,20,30,40 | - | - | - | - | 1 | - |
| Port-Channel3 | POD2_Po49 | switched | trunk | 10,20,30,40 | - | - | - | - | 3 | - |
| Port-Channel1031 | MLAG_PEER_SPINE2_Po1031 | switched | trunk | - | - | ['LEAF_PEER_L3', 'MLAG'] | - | - | - | - |

#### Port-Channel Interfaces Device Configuration

```eos
!
interface Port-Channel1
   description POD1_Po49
   no shutdown
   switchport
   switchport trunk allowed vlan 10,20,30,40
   switchport mode trunk
   mlag 1
!
interface Port-Channel3
   description POD2_Po49
   no shutdown
   switchport
   switchport trunk allowed vlan 10,20,30,40
   switchport mode trunk
   mlag 3
!
interface Port-Channel1031
   description MLAG_PEER_SPINE2_Po1031
   no shutdown
   switchport
   switchport mode trunk
   switchport trunk group LEAF_PEER_L3
   switchport trunk group MLAG
```

### Loopback Interfaces

#### Loopback Interfaces Summary

##### IPv4

| Interface | Description | VRF | IP Address |
| --------- | ----------- | --- | ---------- |
| Loopback0 | Router_ID | default | 10.1.252.1/32 |

##### IPv6

| Interface | Description | VRF | IPv6 Address |
| --------- | ----------- | --- | ------------ |
| Loopback0 | Router_ID | default | - |

#### Loopback Interfaces Device Configuration

```eos
!
interface Loopback0
   description Router_ID
   no shutdown
   ip address 10.1.252.1/32
   ip ospf area 0.0.0.0
```

### VLAN Interfaces

#### VLAN Interfaces Summary

| Interface | Description | VRF |  MTU | Shutdown |
| --------- | ----------- | --- | ---- | -------- |
| Vlan10 | Ten | default | - | False |
| Vlan20 | Twenty | default | - | False |
| Vlan30 | Thirty | default | - | False |
| Vlan40 | Forty | default | - | False |
| Vlan4093 | MLAG_PEER_L3_PEERING | default | 1500 | False |
| Vlan4094 | MLAG_PEER | default | 1500 | False |

##### IPv4

| Interface | VRF | IP Address | IP Address Virtual | IP Router Virtual Address | VRRP | ACL In | ACL Out |
| --------- | --- | ---------- | ------------------ | ------------------------- | ---- | ------ | ------- |
| Vlan10 |  default  |  10.10.10.2/24  |  -  |  10.10.10.1  |  -  |  -  |  -  |
| Vlan20 |  default  |  10.20.20.2/24  |  -  |  10.20.20.1  |  -  |  -  |  -  |
| Vlan30 |  default  |  10.30.30.2/24  |  -  |  10.30.30.1  |  -  |  -  |  -  |
| Vlan40 |  default  |  10.40.40.2/24  |  -  |  10.40.40.1  |  -  |  -  |  -  |
| Vlan4093 |  default  |  10.1.254.0/31  |  -  |  -  |  -  |  -  |  -  |
| Vlan4094 |  default  |  10.1.253.0/31  |  -  |  -  |  -  |  -  |  -  |

#### VLAN Interfaces Device Configuration

```eos
!
interface Vlan10
   description Ten
   no shutdown
   ip address 10.10.10.2/24
   ip ospf area 0.0.0.0
   ip virtual-router address 10.10.10.1
!
interface Vlan20
   description Twenty
   no shutdown
   ip address 10.20.20.2/24
   ip ospf area 0.0.0.0
   ip virtual-router address 10.20.20.1
!
interface Vlan30
   description Thirty
   no shutdown
   ip address 10.30.30.2/24
   ip ospf area 0.0.0.0
   ip virtual-router address 10.30.30.1
!
interface Vlan40
   description Forty
   no shutdown
   ip address 10.40.40.2/24
   ip ospf area 0.0.0.0
   ip virtual-router address 10.40.40.1
!
interface Vlan4093
   description MLAG_PEER_L3_PEERING
   no shutdown
   mtu 1500
   ip address 10.1.254.0/31
   ip ospf network point-to-point
   ip ospf area 0.0.0.0
!
interface Vlan4094
   description MLAG_PEER
   no shutdown
   mtu 1500
   no autostate
   ip address 10.1.253.0/31
```

## Routing

### Service Routing Protocols Model

Multi agent routing protocol model enabled

```eos
!
service routing protocols model multi-agent
```

### Virtual Router MAC Address

#### Virtual Router MAC Address Summary

Virtual Router MAC Address: 00:1c:73:00:dc:01

#### Virtual Router MAC Address Device Configuration

```eos
!
ip virtual-router mac-address 00:1c:73:00:dc:01
```

### IP Routing

#### IP Routing Summary

| VRF | Routing Enabled |
| --- | --------------- |
| default | True |

#### IP Routing Device Configuration

```eos
!
ip routing
```

### IPv6 Routing

#### IPv6 Routing Summary

| VRF | Routing Enabled |
| --- | --------------- |
| default | False |
| default | false |

### Router OSPF

#### Router OSPF Summary

| Process ID | Router ID | Default Passive Interface | No Passive Interface | BFD | Max LSA | Default Information Originate | Log Adjacency Changes Detail | Auto Cost Reference Bandwidth | Maximum Paths | MPLS LDP Sync Default | Distribute List In |
| ---------- | --------- | ------------------------- | -------------------- | --- | ------- | ----------------------------- | ---------------------------- | ----------------------------- | ------------- | --------------------- | ------------------ |
| 1 | 10.1.252.1 | enabled | Vlan4093 <br> | disabled | 12000 | disabled | disabled | - | - | - | - |

#### OSPF Interfaces

| Interface | Area | Cost | Point To Point |
| -------- | -------- | -------- | -------- |
| Vlan10 | 0.0.0.0 | - | - |
| Vlan20 | 0.0.0.0 | - | - |
| Vlan30 | 0.0.0.0 | - | - |
| Vlan40 | 0.0.0.0 | - | - |
| Vlan4093 | 0.0.0.0 | - | True |
| Loopback0 | 0.0.0.0 | - | - |

#### Router OSPF Device Configuration

```eos
!
router ospf 1 vrf default
   router-id 10.1.252.1
   passive-interface default
   no passive-interface Vlan4093
   max-lsa 12000
```

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
