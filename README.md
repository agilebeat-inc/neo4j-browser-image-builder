# Neo4j Browser Container

This repository builds and publishes a multi-architecture Docker image for the Neo4j Browser, using GitHub Actions and Docker Buildx.

## Features
- Automated build and publish workflow via GitHub Actions
- Multi-arch support: `linux/amd64`, `linux/s390x`, `linux/arm64`, `linux/ppc64le`
- Semantic versioning for Docker image tags
- Image signing with Cosign on version branches

## Workflow Overview
- On every push, the workflow runs and builds the Docker image.
- For branches starting with `m` or `v`, the workflow:
  - Generates Docker image metadata and tags using `crazy-max/ghaction-docker-meta`
  - Sets up QEMU and Docker Buildx for multi-arch builds
  - Logs in to DockerHub and pushes the image
  - Signs the image with Cosign on version branches

## Usage
### Build Locally
```bash
make docker_build
```

### Test Locally
```bash
make test
```

### Publish (via GitHub Actions)
Push to a branch starting with `m` or `v` to trigger the publish workflow.

## Docker Image
- Repository: `agilebeat/neo4j-browser`
- Tags: Semantic versioning tags (e.g., `v1.2.3`)

## Security
- Images are signed with Cosign for authenticity on version branches.

## Maintainers
- AgileBeat Inc.

## License
MIT
