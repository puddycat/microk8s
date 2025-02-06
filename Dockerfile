#
# microk8s/Dockerfile
#
#   Create a Lab Kubernetes microk8s image.
#
#   See:
#     https://microk8s.io/
#
#   docker build -f Dockerfile  \
#       --build-arg BASE_IMAGE="ubuntu" \
#       --build-arg BASE_IMAGE_TAG="20.04" \
#       -t raymondstrose/microk8s:20.04 .
#

ARG	BASE_IMAGE="ubuntu"
ARG	BASE_IMAGE_TAG="20.04"

FROM $BASE_IMAGE:$BASE_IMAGE_TAG
LABEL MAINTAINER=raymondstrose@hotmail.com

ENV container=docker
ENV LC_ALL=C
ENV DEBIAN_FRONTEND=noninteractive

# Install open-iscsi for Longhorn.
#RUN apt-get update && apt-get install -y open-iscsi sudo systemctl snapd systemd
RUN apt-get update && apt-get install -y open-iscsi sudo snapd systemd

RUN apt-get update && apt-get install -y systemd systemd-sysv && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN apt-get clean all

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
RUN rm -f /lib/systemd/system/multi-user.target.wants/*	\
	/etc/systemd/system/*.wants/*	\
	/lib/systemd/system/local-fs.target.wants/*	\
	/lib/systemd/system/sockets.target.wants/*udev*	\
	/lib/systemd/system/sockets.target.wants/*initctl*	\
	/lib/systemd/system/basic.target.wants/*	\
	/lib/systemd/system/anaconda.target.wants/*	\
	/lib/systemd/system/plymouth*	\
	/lib/systemd/system/systemd-update-utmp*
RUN cd /lib/systemd/system/sysinit.target.wants/ && rm $(ls | grep -v systemd-tmpfiles-setup)
#RUN /bin/sh -c cd /lib/systemd/system/sysinit.target.wants/     && rm $(ls | grep -v systemd-tmpfiles-setup)

VOLUME [/sys/fs/cgroup]

#ENTRYPOINT ["/home/microk8s/entrypoint", "--debug", "--verbose"]
#ENTRYPOINT ["/lib/systemd/systemd"]
CMD ["/home/microk8s/entrypoint", "--debug", "--verbose"]
CMD ["/lib/systemd/systemd"]
