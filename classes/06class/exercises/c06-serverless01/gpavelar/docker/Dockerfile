FROM ubuntu:18.04 as aws

################################
# Install AWS
################################

RUN apt-get update && apt-get install curl wget make unzip sudo python3 -y && \
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
  unzip awscliv2.zip && \
  sudo ./aws/install && \
  rm -rf /var/lib/apt/lists/*

## Defines the default executable of a Docker image.
CMD [ "bash" ] 

################################
# Install Terraform
################################

# Download terraform for linux
RUN wget https://releases.hashicorp.com/terraform/0.13.2/terraform_0.13.2_linux_amd64.zip

# Unzip
RUN unzip terraform_0.13.2_linux_amd64.zip

# Move to local bin
RUN mv terraform /usr/local/bin/
# Check that it's installed
RUN terraform --version 