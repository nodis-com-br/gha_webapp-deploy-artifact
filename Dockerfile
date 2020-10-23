FROM amazon/aws-cli

RUN yum install -y tar

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]