# About

This is a OCI-layer container runtime written in Shell.

# Install

```bash
sudo apt install docker.io
sudo apt install cgroup-tools
git clone https://github.com/k-onishi/runb/
cd runb
```

# Quickstart

```bash
mkdir containers
sudo bash tool/setup_filesystem.sh containers/ ubuntu
sudo bash tool/setup_bridge.sh
sudo bash runb.sh containers/ubuntu/
```

# Tools

- make file system for container

```bash
bash tool/setup_filesystem.sh [containers dir] [distro name]
```

- make network bridge

```bash
bash tool/setup_bridge.sh
```
