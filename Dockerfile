FROM jenkinsci/jnlp-slave
# Metadata
LABEL org.label-schema.vcs-url="https://github.com/derwasp/jenkins-jnlp-dind" \
      org.label-schema.docker.dockerfile="/Dockerfile"
USER root

# .NET Core 1.0.3 #
RUN apt-get update && apt-get install curl libunwind8 gettext -y
RUN curl -sSL -o /tmp/dotnet.tar.gz https://go.microsoft.com/fwlink/?LinkID=836302
RUN mkdir -p /opt/dotnet && tar zxf /tmp/dotnet.tar.gz -C /opt/dotnet
RUN ln -s /opt/dotnet/dotnet /usr/local/bin

# Python + AWS CLI
RUN apt-get install python3.4 -y
RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" && \
    unzip ./awscli-bundle.zip && \
    ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

# Zip
RUN apt-get install -y zip

COPY start-slave /usr/local/bin/start-slave
ENTRYPOINT [ "start-slave" ]