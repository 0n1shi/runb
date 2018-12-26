# About

This is a OCI-layer container runtime for studying.

# Run

1. Create a container image with Docker.

```bash
bash tools/setup_filesystem.sh ubuntu
```

2. Run the container on runB.

```bash
bash runb.sh containers/ubuntu
```

# Tools

## Create a containr image.

```bash
bash tools/setup_filesystem.sh ubuntu
```

## Create a network bridge.

```bash
bash tools/setup_bridge.sh
```
