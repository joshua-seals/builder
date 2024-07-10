ARG BASE_IMAGE=ubuntu:22.04

FROM ${BASE_IMAGE}
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y curl unzip dos2unix wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/tmp/*

RUN mkdir -p /autograder/source && \
    mkdir -p /autograder/submission && \
    mkdir -p /autograder/results

ENV BASE_IMAGE=$BASE_IMAGE
COPY /build-wants/autograder /autograder/run_autograder
COPY /build-wants/setup.sh /build-wants/environment.yml /build-wants/otter_config.json /build-wants/run_otter.py /build-wants/requirements.* \
    /build-wants/files* \
    /build-wants/tests \
    /autograder/source
# ADD build-wants/run_autograder /autograder/run_autograder \
#     build-wants/setup.sh build-wants/environment.yml build-wants/otter_config.json build-wants/run_otter.py build-wants/requirements.* \
#     build-wants/files* \
#     build-wants/tests \
#     /autograder/source/


RUN dos2unix /autograder/run_autograder /autograder/source/setup.sh && \
    chmod +x /autograder/run_autograder && \
    apt-get update && bash /autograder/source/setup.sh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
