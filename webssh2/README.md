# WebSSH2 on Alpine
## Description
Web SSH Client using [WebSSH2](https://github.com/billchurch/WebSSH2) (ssh2, socket.io, xterm.js) on Alpline.

## Usage
- `docker run --rm -it --name webssh2 -p 2222:2222 psharkey/webssh2`
- Browse to `http://localhost:2222/ssh/host/<SOME_SSH_SERVER>`
- Enter your credentials for `<SOME_SERVER>`

## On DockerHub / GitHub
___
* DockerHub [psharkey/webssh2](https://hub.docker.com/r/psharkey/webssh2/)
* GitHub [psharkey/docker/webssh2](https://github.com/psharkey/docker/tree/webssh2/webssh2)
