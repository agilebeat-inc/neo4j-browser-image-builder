#
# Docker Image Usage (for inclusion in the image root)
#

This image provides a multi-architecture build of the Neo4j Browser, served via a Koa web server.

## Usage

Run the container:
```bash
docker run -p 3000:3000 agilebeat/neo4j-browser:latest
```

Then open your browser at http://localhost:3000

## Supported Architectures
- amd64 (x86_64)

## Security
- Images are signed with Cosign for authenticity on version branches.

## Maintainers
AgileBeat Inc.

## License
MIT
