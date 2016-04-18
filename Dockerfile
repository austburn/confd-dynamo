FROM ubuntu:14.04

# Used for debugging
RUN apt-get update && apt-get install -y python-pip groff
RUN pip install awscli

# Default confd does not work for me
# ADD https://github.com/kelseyhightower/confd/releases/download/v0.10.0/confd-0.10.0-linux-amd64 /usr/local/bin/confd
ADD bin/confd /usr/local/bin/confd
RUN chmod +x /usr/local/bin/confd
COPY confd/ /etc/confd/

# Default region
ENV AWS_REGION us-east-1
RUN mkdir /root/.aws && touch /root/.aws/credentials /root/.aws/config
CMD /usr/local/bin/confd -onetime -backend env -confdir /etc/confd/aws/ && \
    /usr/local/bin/confd -onetime -backend dynamodb -table confd -confdir /etc/confd/certs/ && \
    cat ~/cert
