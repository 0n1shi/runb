# About

This is a OCI-layer container runtime for studying.

# Run

```bash
mkdir containers
sudo bash tool/setup_filesystem.sh containers/ ubuntu
sudo bash tools/setup_bridge.sh
sudo bash runb.sh containers/ubuntu/
```
