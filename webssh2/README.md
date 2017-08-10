# WebSSH2 on Alpine
## Description
Web SSH Client using ssh2, socket.io, xterm.js using [WebSSH2](https://github.com/billchurch/WebSSH2) on Alpline. 

## Usage
- `docker run --rm -it --name webssh2 -p 2222:2222 psharkey/webssh2`
- Browse to `http://localhost:2222/ssh/host/<SOME_SSH_SERVER>`
- Enter your credentials for `<SOME_SERVER>`
