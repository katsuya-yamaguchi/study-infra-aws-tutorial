FROM alpine:3.15.0

ARG AWS_ACCESS_KEY
ARG AWS_SECRET_ACCESS_KEY
ARG ENV

ENV TF_URL https://releases.hashicorp.com/terraform/1.0.11/terraform_1.0.11_linux_amd64.zip
ENV ROOT_PATH /root
ENV INFRA_ROOT /tf

WORKDIR ${ROOT_PATH}
RUN apk update && \
    wget -q -O terraform.zip ${TF_URL} && \
    unzip terraform.zip && \
    rm -fr terraform.zip && \
    mv terraform /usr/local/bin/ && \
    rm -fr /var/cache/apk/

WORKDIR ${ROOT_PATH}/.aws
RUN echo '[default]' >> config && \
    echo 'region = ap-northeast-1' >> config && \
    echo 'output = json' >> config && \
    echo '[default]' >> credentials && \
    echo "aws_access_key_id = ${AWS_ACCESS_KEY}" >> credentials && \
    echo "aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}" >> credentials

COPY ./modules ${INFRA_ROOT}/modules
COPY ./staging ${INFRA_ROOT}/staging

WORKDIR ${INFRA_ROOT}/${ENV}
CMD ["/bin/ash", "-c", "while :; do sleep 10; done;"]
