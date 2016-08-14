# Ansible on Apline

Ansible installation on Alpine 3.4. Based on [williamyey/ansible](https://hub.docker.com/r/williamyeh/ansible/). Includes support for provisioning Windows machines.

## Remote System Requirements

The remote system must be preppared according to the type:

* [Windows](http://docs.ansible.com/ansible/intro_windows.html#windows-system-prep)
* [SSH](http://docs.ansible.com/ansible/intro_getting_started.html#remote-connection-information)

## Onbuild

### Onbuild Image

From the directory containing the Dockerfile:

```bash
docker build -t ansible -f Dockerfile.onbuild .
```

### Onbuild Test

Use the `ansible --version` command to perform a simple test which displays the Ansible version in the container: 

```bash
$ docker run --rm -it ansible ansible --version
ansible 2.1.1.0
  config file = 
  configured module search path = Default w/o overrides
$
```

## Docker Test Target

### Test Target Build

```bash
docker build -t sshd -f Dockerfile.sshd .
```

### Test Target Run

```bash
docker run -d --name sshd -p 22 sshd
```

## Linked Docker Tests

### Installing python-simplejson

```bash
# docker run --rm -it --link sshd ansible ansible docker -m raw -a 'apt-get -qy install python-simplejson'
sshd | SUCCESS | rc=0 >>
Reading package lists...
>>> LINES OMMITTED FOR BREVITY <<<
Unpacking python-simplejson (3.8.1-1ubuntu2) ...
Setting up libffi6:amd64 (3.2.1-4) ...
Setting up libpython2.7-stdlib:amd64 (2.7.12-1~16.04) ...
Setting up python2.7 (2.7.12-1~16.04) ...
Setting up libpython-stdlib:amd64 (2.7.11-1) ...
Setting up python (2.7.11-1) ...
Setting up javascript-common (11) ...
Setting up libjs-jquery (1.11.3+dfsg-4) ...
Setting up python-simplejson (3.8.1-1ubuntu2) ...
Processing triggers for libc-bin (2.23-0ubuntu3) ...

#
```

### Linked Ping Test

```bash
# docker run --rm -it --link sshd ansible ansible docker -m ping
sshd | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}
#
```


## Executing Commands on Windows

### Ping the Windows Box

The `ansible <inventory> -m win-ping` command may be used to attempt to ping the target.

```bash
$ docker run --rm -it ansible ansible windows -m win_ping
10.10.101.173 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
$
```

### Raw Commands

The `raw` module may be used to issue raw commands (like `DIR` to list the contents of the remote directory):

```bash
$ docker run --rm -it ansible ansible windows -m raw -a "CMD /C dir"
10.10.101.173 | SUCCESS | rc=0 >>
 Volume in drive C is Windows 10
 Volume Serial Number is 905D-2DA8

 Directory of C:\Users\Administrator

08/12/2016  11:51 AM    <DIR>          .
08/12/2016  11:51 AM    <DIR>          ..
08/12/2016  11:51 AM    <DIR>          .ansible
08/12/2016  12:18 PM                10 .bash_history
07/16/2016  04:47 AM    <DIR>          Desktop
08/12/2016  11:45 AM    <DIR>          Documents
07/16/2016  04:47 AM    <DIR>          Downloads
07/16/2016  04:47 AM    <DIR>          Favorites
07/16/2016  04:47 AM    <DIR>          Links
07/16/2016  04:47 AM    <DIR>          Music
07/16/2016  04:47 AM    <DIR>          Pictures
07/16/2016  04:47 AM    <DIR>          Saved Games
07/16/2016  04:47 AM    <DIR>          Videos
               1 File(s)             10 bytes
              12 Dir(s)  29,668,818,944 bytes free


$
```

### Other Modules

Refer to [Windows Modules](http://docs.ansible.com/ansible/list_of_windows_modules.html) for a listing an description of other available modules.
