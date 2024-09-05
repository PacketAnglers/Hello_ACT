# Setup AVD and ZSH on Tools-Server node

The tools-server node comes with basic tools installed. We will update the node to support:

- AVD 4.10.1
- ZSH

In tool-server VSCode, click File > Open Folder and open the cvpadmin folder. Next, make a new directory and clone the repo using the following commands.

``` bash
mkdir git-projects
cd git-projects
git clone https://github.com/PacketAnglers/Hello_ACT.git
```

Click File > Open Folder and open cvpadmin/git-projects/Hello_ACT

Install AVD and requirements

``` bash
pip install "pyavd[ansible]==4.10.1"
ansible-galaxy collection install arista.avd:==4.10.1
```

Install zsh

``` bash
sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)" -- \
    -t robbyrussell \
    -p git \
    -p ssh-agent \
    -a 'alias pip="pip3"' \
    -a 'alias python="python3"'
```

type 'zsh' at the shell to open Zsh shell

``` bash
zsh
```

Verify tun0 interface is up and configured wsith 192.168.0.6/24.

``` bash
ifconfig
```

When initially building the tools-server, the IP will be active.  After restarting the lab,
you may find the IP is missing on `tun0` interface.

You can add it manually each time with the following command:

``` bash
ip addr add 192.168.0.6/24 dev tun0
```

Or you can edit the /etc/rc.local file and add the above line at the top of the file.

/etc/rc.local will look like this:

``` bash
#!/bin/sh

# Check if vx-tun0 exists and delete it
if ip link show vx-tun0 > /dev/null 2>&1; then
    ip link delete vx-tun0
fi
# Check if tun0 exists and delete it
if ip link show tun0 > /dev/null 2>&1; then
    ip link delete tun0
fi
# Add the new veth pair
ip link add dev vx-tun0 type veth peer name tun0
ip link set dev tun0 up
ip link set dev vx-tun0 up

ip addr add 192.168.0.6/24 dev tun0
```
