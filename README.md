# tensorflow-swift-docker
a collection of helpers for using tensorflow-swift in docker.

## building
```sh
./download.sh
./build.sh
```

this will build a docker image `kazimuth2/tensorflow-swift-docker`. it should take only a few minutes if you've got a fast connection.

note that you need a docker daemon with `--experimental` to enable the advanced docker-buildkit features used in the Dockerfile.

## usage
add the `bin` directory to your path.

now, you have access to the following commands:

- `tfs-start`
- `tfs-enter`
- `tfs-exec`
- `tfs-swift`
- `tfs-swiftc`
- `tfs-sourcekit-lsp`

`tfs-start` boots a docker container named `tfs-daemon` with the tensorflow-swift-docker image. the container has your home directory mounted at its normal path. the other commands try to run `tfs-start`. however, if you're not in the `docker` group, that might not work; you should run `sudo tfs-start` before using them to boot the daemon instead.

`tfs-enter` drops you into a shell in the container, wherever you are in the host filesystem.

`tfs-exec` runs a command in the container.

`tfs-swift`, `tfs-swiftc`, and `tfs-sourcekit-lsp` execute their corresponding commands in the container.

you can use them like so:

```sh
# on the host
git clone https://github.com/tensorflow/swift-models
cd swift-models
tfs-swift package update
tfs-swift build -c release
tfs-exec .build/release/LeNet-MNIST

# .build/release/LeNet-MNIST -- this won't work, the binary needs system libraries that are only in the container
```

## todo
- setuid within container to match outer uid
- nvidia docker support
- script to extract binary with dependencies for shipping
