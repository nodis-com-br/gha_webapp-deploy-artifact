FROM amazon/aws-cli

RUN yum install -y tar gzip

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]