MicroK8s
========
MicroK8s is a lightweight, zero-ops Kubernetes for Linux, Windows and macOS. A single command installs all upstream Kubernetes services and their dependencies. With support for x86 and ARM64, MicroK8s runs from local workstations to the edge and IoT appliances.

Issues
------
- The container fails on start as follows:
```
% docker run -it --tmpfs /tmp --tmpfs /run --tmpfs /run/lock  raymondstrose/microk8s:ubuntu-20.04
systemd 245.4-4ubuntu3.24 running in system mode. (+PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN2 -IDN +PCRE2 default-hierarchy=hybrid)
Detected virtualization docker.
Detected architecture arm64.

Welcome to Ubuntu 20.04.6 LTS!

Set hostname to <3b91ff0b47c2>.
Failed to create /init.scope control group: Read-only file system
Failed to allocate manager object: Read-only file system
[!!!!!!] Failed to allocate manager object.
Exiting PID 1...# microk8s
```
Further Reading
---------------
- [Canonical Kubernetes for multi-cloud operations](https://ubuntu.com/kubernetes)
- [DockerHub: jrei/systemd-ubuntu](https://hub.docker.com/r/jrei/systemd-ubuntu)
