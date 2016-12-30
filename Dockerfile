FROM jenkinsci/jnlp-slave

# Metadata
LABEL org.label-schema.vcs-url="https://github.com/derwasp/jenkins-jnlp-dind" \
      org.label-schema.docker.dockerfile="/Dockerfile"

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
        g++ \
        gcc \
        libc6-dev \
        make \
        jq \
    && rm -rf /var/lib/apt/lists/*

RUN wget -qO- https://get.docker.com/ | sh

# mono #

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
    && echo "deb http://download.mono-project.com/repo/debian wheezy main" | tee /etc/apt/sources.list.d/mono-xamarin.list \
    && echo "deb http://download.mono-project.com/repo/debian wheezy-apache24-compat main" | tee -a /etc/apt/sources.list.d/mono-xamarin.list \
    && echo "deb http://download.mono-project.com/repo/debian wheezy-libjpeg62-compat main" | tee -a /etc/apt/sources.list.d/mono-xamarin.list \
    && apt-get update \
    && apt-get install mono-complete -y

# end mono #

# .NET Core #

RUN apt-get update && apt-get install curl libunwind8 gettext -y
RUN curl -sSL -o /tmp/dotnet.tar.gz https://go.microsoft.com/fwlink/?LinkID=835021
RUN mkdir -p /opt/dotnet && tar zxf /tmp/dotnet.tar.gz -C /opt/dotnet
RUN ln -s /opt/dotnet/dotnet /usr/local/bin

# end .NET Core #

COPY start-docker-and-slave /usr/local/bin/start-docker-and-slave

ENTRYPOINT ["start-docker-and-slave"]
