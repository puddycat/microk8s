#
# microk8s/Dockerfile
#
#   Create a Lab Kubernetes microk8s image.
#
#   See:
#   - https://microk8s.io/
#   - https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
#
#   docker build -f Dockerfile  \
#       --build-arg BASE_IMAGE="ubuntu" \
#       --build-arg BASE_IMAGE_TAG="20.04" \
#       -t raymondstrose/microk8s:20.04 .
#

#ARG BASE_IMAGE="ubuntu"
#ARG BASE_IMAGE_TAG="20.04"
ARG BASE_IMAGE="debian"
ARG BASE_IMAGE_TAG="12.9-slim"

FROM $BASE_IMAGE:$BASE_IMAGE_TAG
LABEL MAINTAINER=raymondstrose@hotmail.com

ENV container=docker
ENV LC_ALL=C
ENV DEBIAN_FRONTEND=noninteractive

# Install open-iscsi for Longhorn.
#RUN apt-get update && apt-get install -y open-iscsi sudo systemctl snapd systemd
#RUN apt-get update && apt-get install -y open-iscsi sudo snapd systemd
RUN apt-get update && apt-get install -y open-iscsi sudo systemctl

#RUN apt-get update && apt-get install -y systemd systemd-sysv && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN apt-get clean all

# Install containerd runtime
RUN apt-get install -y containerd

# Install kubeadm, kubectl and kubelet (see: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)

# apt-transport-https may be a dummy package; if so, you can skip that package
RUN sudo apt-get install -y apt-transport-https ca-certificates curl gpg

# If the directory `/etc/apt/keyrings` does not exist, it should be created before the curl command, read the note below.
RUN sudo mkdir -p -m 755 /etc/apt/keyrings
RUN curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
RUN echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

RUN sudo apt-get update
RUN sudo apt-get install -y kubelet kubeadm kubectl
RUN sudo apt-mark hold kubelet kubeadm kubectl

RUN sudo systemctl enable --now kubelet

#RUN sudo snap install microk8s --classic
#
#RUN microk8s status --wait-ready
#
#RUN microk8s enable dashboard
#RUN microk8s enable dns
#RUN microk8s enable registry
#RUN microk8s enable istio

# Copy the entrypoint into the container.
COPY entrypoint /home/microk8s/entrypoint

#RUN /bin/sh -c rm -f /lib/systemd/system/multi-user.target.wants/*     /etc/systemd/system/*.wants/*     /lib/systemd/system/local-fs.target.wants/*     /lib/systemd/system/sockets.target.wants/*udev*     /lib/systemd/system/sockets.target.wants/*initctl*     /lib/systemd/system/basic.target.wants/*     /lib/systemd/system/anaconda.target.wants/*     /lib/systemd/system/plymouth*     /lib/systemd/system/systemd-update-utmp*
#RUN rm -f /lib/systemd/system/multi-user.target.wants/*	\
#	/etc/systemd/system/*.wants/*	\
#	/lib/systemd/system/local-fs.target.wants/*	\
#	/lib/systemd/system/sockets.target.wants/*udev*	\
#	/lib/systemd/system/sockets.target.wants/*initctl*	\
#	/lib/systemd/system/basic.target.wants/*	\
#	/lib/systemd/system/anaconda.target.wants/*	\
#	/lib/systemd/system/plymouth*	\
#	/lib/systemd/system/systemd-update-utmp*
#RUN cd /lib/systemd/system/sysinit.target.wants/ && rm $(ls | grep -v systemd-tmpfiles-setup)
#RUN /bin/sh -c cd /lib/systemd/system/sysinit.target.wants/     && rm $(ls | grep -v systemd-tmpfiles-setup)

VOLUME [/sys/fs/cgroup]

#ENTRYPOINT ["/home/microk8s/entrypoint", "--debug", "--verbose"]
#ENTRYPOINT ["/lib/systemd/systemd"]
CMD ["/home/microk8s/entrypoint", "--debug", "--verbose"]
#CMD ["/lib/systemd/systemd"]
