# docker-publish-ghcr

[中文文档](README.zh_cn.md) | **English**

A GitHub Composite Action to build Docker images and push to GitHub Packages (ghcr.io) with one click.

## Features

- ✅ **Automatic Tag Management** - Git tag auto-detection, semantic versioning
- ✅ **Multi-Platform Build** - Support linux/amd64, linux/arm64 cross-platform builds
- ✅ **Build Cache Acceleration** - GitHub Actions cache for faster builds
- ✅ **Configurable Parameters** - Flexible inputs for various scenarios
- ✅ **QEMU Auto-Detection** - Automatically enables QEMU for cross-platform builds

## Usage

### Basic Usage

```yaml
name: Build and Push Docker Image

on:
  push:
    tags: ['v*.*.*']

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Publish to GHCR
        uses: your-username/docker-publish-ghcr@v1
        with:
          image_name: your-username/your-repo
```

### Full Configuration

```yaml
name: Build and Push Docker Image

on:
  push:
    branches: ['main']
    tags: ['v*.*.*']

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Publish to GHCR
        uses: your-username/docker-publish-ghcr@v1
        with:
          image_name: your-username/your-repo
          tag: ''                        # Auto-detects git tag or uses commit SHA
          latest_tag: 'true'             # Add latest tag
          docker_context: '.'            # Docker build context
          dockerfile: 'Dockerfile'       # Dockerfile path
          platforms: linux/amd64,linux/arm64  # Empty = runner's native architecture
          push: 'true'                   # Push image (set false for PR builds)
          build_args: |                  # Docker build arguments
            ARG1=value1
            ARG2=value2
```

## Inputs

| Parameter | Required | Default | Description |
|-----------|----------|---------|-------------|
| `image_name` | ✅ | - | Image name (format: `username/repo`) |
| `tag` | ❌ | `''` | Image tag. Auto-detects git tag or uses commit SHA if empty |
| `latest_tag` | ❌ | `'true'` | Add `latest` tag |
| `docker_context` | ❌ | `'.'` | Docker build context directory |
| `dockerfile` | ❌ | `'Dockerfile'` | Dockerfile path |
| `platforms` | ❌ | `''` | Build platforms (comma-separated). Empty = runner's native architecture. QEMU is automatically enabled for cross-platform builds |
| `push` | ❌ | `'true'` | Whether to push the image |
| `build_args` | ❌ | `''` | Docker build arguments (one per line) |

## Tag Strategy

| Trigger | Generated Tags |
|---------|----------------|
| `tag` parameter specified | `ghcr.io/user/repo:<tag>` + `latest` |
| Git tag (e.g., v1.2.3) | `ghcr.io/user/repo:v1.2.3` + `latest` |
| Regular push | `ghcr.io/user/repo:<commit-sha>` + `latest` |

## Requirements

1. **GitHub Token Permissions** - Requires `packages: write` permission
2. **Dockerfile** - Must exist at root or specified path

### Minimum Permissions

Configure Workflow permissions in GitHub Actions:

```yaml
permissions:
  contents: read
  packages: write
```

## Examples

### Example 1: Build Only on Git Tag

```yaml
on:
  push:
    tags: ['v*.*.*']

jobs:
  build:
    steps:
      - uses: actions/checkout@v4
      - uses: your-username/docker-publish-ghcr@v1
        with:
          image_name: your-username/your-repo
```

### Example 2: Build but Don't Push on PR

```yaml
on:
  pull_request:
    branches: ['main']
  push:
    branches: ['main']

jobs:
  build:
    steps:
      - uses: actions/checkout@v4
      - uses: your-username/docker-publish-ghcr@v1
        with:
          image_name: your-username/your-repo
          push: ${{ github.event_name != 'pull_request' }}
```

### Example 3: Multi-Architecture Build

```yaml
- uses: your-username/docker-publish-ghcr@v1
  with:
    image_name: your-username/your-repo
    platforms: linux/amd64,linux/arm64,linux/arm/v7
```

> **Note:** When specifying platforms different from the runner's architecture, QEMU is automatically enabled for cross-platform emulation.

## License

MIT
