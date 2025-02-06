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

# Install open-iscsi for Longhorn.
#RUN apt-get update && apt-get install -y open-iscsi sudo systemctl snapd systemd
RUN apt-get update && apt-get install -y open-iscsi sudo snapd systemd

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

ENTRYPOINT ["/home/microk8s/entrypoint", "--debug", "--verbose"]
