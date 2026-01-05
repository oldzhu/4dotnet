# Build with a container (Docker/Podman)

This repo is a Buildroot external tree. The container workflow avoids installing most build dependencies on your host.

## Prerequisites (host)

- Either **Docker** or **Podman** installed
- Enough disk space (Buildroot downloads + output can be many GB)

## Quick start (arm64)

From the `4dotnet/` folder:

1. Build the container image (one-time):

~~~
./tools/build-env/run.sh --build
~~~

2. Configure Buildroot for arm64 (uses your existing defconfig):

~~~
./tools/build-env/run.sh -- make distclean
./tools/build-env/run.sh -- make BR2_EXTERNAL=/work/4dotnet defconfig \
  BR2_DEFCONFIG=/work/4dotnet/savedconfigs/arm64/br2.defconfig
~~~

3. Build:

~~~
./tools/build-env/run.sh -- make
~~~

## Quick start (arm)

~~~
./tools/build-env/run.sh -- make distclean
./tools/build-env/run.sh -- make BR2_EXTERNAL=/work/4dotnet defconfig \
  BR2_DEFCONFIG=/work/4dotnet/savedconfigs/arm/br2.defconfig
./tools/build-env/run.sh -- make
~~~

## Notes

- The wrapper mounts:
  - `buildroot/` at `/work/buildroot`
  - `4dotnet/` at `/work/4dotnet`
- It sets `HOME=/work` inside the container, so scripts that reference `$HOME/buildroot` continue to work.
- If your `buildroot/` folder is not a sibling of `4dotnet/`, run:

~~~
BUILDROOT_DIR=/abs/path/to/buildroot ./tools/build-env/run.sh -- make
~~~

## If the image build fails (network/proxy)

Some networks block Docker build traffic or require proxies.

- Use host networking for the image build:

~~~
BUILD_NETWORK=host ./tools/build-env/run.sh --build
~~~

- Use a different Ubuntu mirror (example mirror; choose one close to you):

~~~
APT_MIRROR=http://<your-mirror>/ubuntu/ APT_SECURITY_MIRROR=http://<your-mirror>/ubuntu/ \
  ./tools/build-env/run.sh --build
~~~

- If you are behind a proxy, export `http_proxy` / `https_proxy` / `no_proxy` on the host;
  the build wrapper passes them through as build args.
