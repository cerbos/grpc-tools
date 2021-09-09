Cerbos gRPC Tools
=====================

A container image for generating gRPC stubs in various languages for accessing the [Cerbos](https://cerbos.dev) API. 

Usage
-----

- Create a `buf.gen.yaml` specifying the code generation plugin to use and the location to output the generated code
- Run the container mounting the directory containing `buf.gen.yaml` to `/work` 

**Example: Generating Python stubs**

Create the `buf.gen.yaml` file with the following content. The `out` field specifies that the generated code should be output to the `cerbos/genpb` directory relative to the location of `buf.gen.yaml`.


```yaml
---
version: v1
plugins:
  - name: python
    out: /work/cerbos/genpb
    strategy: all
  - name: python-grpc
    out: /work/cerbos/genpb
    strategy: all
```

Run code generation:

```sh
mkdir -p cerbos/genpb
docker run --rm \
    --mount type=bind,source="$(pwd)",target=/work \
    --mount type=tmpfs,destination=/source \
    ghcr.io/cerbos/grpc-tools:latest
```





