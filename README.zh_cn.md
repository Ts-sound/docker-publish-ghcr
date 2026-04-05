# docker-publish-ghcr

**中文** | [English Documentation](README.md)

一键构建 Docker 镜像并发布到 GitHub Packages (ghcr.io) 的 GitHub Composite Action。

## 功能特性

- ✅ **自动标签管理** - 支持 git tag 自动检测，语义化版本
- ✅ **多平台构建** - 支持 linux/amd64, linux/arm64 等跨平台构建
- ✅ **构建缓存加速** - 使用 GitHub Actions 缓存加速构建
- ✅ **可配置参数** - 灵活的输入参数满足各种场景
- ✅ **QEMU 自动检测** - 跨平台构建时自动启用 QEMU

## 使用方式

### 基本用法

```yaml
name: Build and Push Docker Image

on:
  push:
    tags: ['v*.*.*']

permissions:
  contents: read
  packages: write

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

### 完整配置示例

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
          tag: ''                        # 空则自动使用 git tag 或 commit SHA
          latest_tag: 'true'             # 是否添加 latest 标签
          docker_context: '.'            # Docker 构建上下文
          dockerfile: 'Dockerfile'       # Dockerfile 路径
          platforms: linux/amd64,linux/arm64  # 空 = 使用运行器原生架构
          push: 'true'                   # 是否推送 (PR 时可设为 false)
          build_args: |                  # Docker 构建参数
            ARG1=value1
            ARG2=value2
```

## 输入参数

| 参数 | 必填 | 默认值 | 说明 |
|------|------|--------|------|
| `image_name` | ✅ | - | 镜像名称 (格式：`username/repo`) |
| `tag` | ❌ | `''` | 镜像标签。空则自动使用 git tag 或 commit SHA |
| `latest_tag` | ❌ | `'true'` | 是否添加 `latest` 标签 |
| `docker_context` | ❌ | `'.'` | Docker 构建上下文目录 |
| `dockerfile` | ❌ | `'Dockerfile'` | Dockerfile 路径 |
| `platforms` | ❌ | `''` | 构建平台 (逗号分隔)。空 = 使用运行器原生架构。跨平台时自动启用 QEMU |
| `push` | ❌ | `'true'` | 是否推送镜像 |
| `build_args` | ❌ | `''` | Docker 构建参数 (每行一个) |

## 标签策略

| 触发条件 | 生成的标签 |
|----------|------------|
| `tag` 参数指定 | `ghcr.io/user/repo:<tag>` + `latest` |
| git tag (如 v1.2.3) | `ghcr.io/user/repo:v1.2.3` + `latest` |
| 普通 push | `ghcr.io/user/repo:<commit-sha>` + `latest` |

## 前置要求

1. **GitHub Token 权限** - 需要 `packages: write` 权限
2. **Dockerfile** - 项目根目录或指定路径需有 Dockerfile

### 最小权限配置

在 GitHub Actions 中配置 Workflow 权限：

```yaml
permissions:
  contents: read
  packages: write
```

## 示例场景

### 场景 1: 仅在 git tag 时发布

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

### 场景 2: PR 时仅构建不推送

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

### 场景 3: 多架构构建

```yaml
- uses: your-username/docker-publish-ghcr@v1
  with:
    image_name: your-username/your-repo
    platforms: linux/amd64,linux/arm64,linux/arm/v7
```

> **注意：** 当指定与运行器不同的平台时，QEMU 会自动启用来进行跨平台模拟构建。

## 许可证

MIT
