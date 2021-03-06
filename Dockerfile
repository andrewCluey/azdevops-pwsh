FROM mcr.microsoft.com/powershell:lts-ubuntu-16.04

# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
       ca-certificates \
       curl \
       jq \
       git \
       iputils-ping \
       libcurl3 \
       libicu55 \
       libunwind8 \
       netcat \
       openssh-client \
       unzip \
       wget

# Start PowerShell
RUN pwsh -c "Set-PSRepository -Name PSGallery -InstallationPolicy Trusted" && \
pwsh -c "\$ProgressPreference = \"SilentlyContinue\"; Install-Module -Name AWSPowerShell.NetCore" && \
pwsh -c "\$ProgressPreference = \"SilentlyContinue\"; Install-Module -Name Az -AllowPrerelease" 

# Install azcopy
RUN wget https://aka.ms/downloadazcopy-v10-linux
# Expand Archive
RUN tar -xvf downloadazcopy-v10-linux
#Move AzCopy to the destination you want to store it
RUN cp ./azcopy_linux_amd64_*/azcopy /usr/bin/

WORKDIR /azp

COPY ./start.sh .
RUN chmod +x start.sh

CMD ["./start.sh"]
