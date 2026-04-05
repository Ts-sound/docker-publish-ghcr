# Docker Publish to GHCR Action
一键构建Docker镜像并自动发布到 GitHub Packages (ghcr.io)

## 快速使用
```yaml
name: Deploy
on:
  push:
    branches: [main]

permissions:
  packages: write
  contents: read

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: 你的用户名/docker-publish-ghcr@v1
        with:
          image_name: ${{ github.repository }}
```