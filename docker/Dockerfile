FROM debian:bookworm-slim AS base

RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    unzip \
    openssh-client \
    bash \
    ca-certificates \
    jq \
    && rm -rf /var/lib/apt/lists/*

ENV PATH="/root/.local/bin:$PATH"
RUN curl -LsSf https://astral.sh/uv/install.sh | sh && \
    uv python install 3.12 && \
    ln -s $(uv python find 3.12) /usr/local/bin/python3 && \
    ln -s /usr/local/bin/python3 /usr/local/bin/python

ARG TERRAFORM_VERSION=1.10.3
RUN wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    terraform --version

RUN uv tool install ansible-core --with boto3 --with botocore && \
    ansible --version

RUN ansible-galaxy collection install \
    amazon.aws \
    community.general

ARG KUBECTL_VERSION=1.32.0
RUN curl -LO "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/ && \
    kubectl version --client

ARG TALOS_VERSION=v1.11.2
RUN curl -sL https://github.com/siderolabs/talos/releases/download/${TALOS_VERSION}/talosctl-linux-amd64 -o /usr/local/bin/talosctl && \
    chmod +x /usr/local/bin/talosctl && \
    talosctl version --client

WORKDIR /workspace

FROM base AS terraform-deploy

WORKDIR /workspace/terraform

ONBUILD COPY terraform/ /workspace/terraform/

RUN --mount=type=secret,id=env \
    if [ -f /run/secrets/env ]; then \
        export $(cat /run/secrets/env | xargs) && \
        terraform init && \
        terraform validate; \
    fi

FROM base AS ansible-deploy

WORKDIR /workspace

ONBUILD COPY ansible/requirements.yml /workspace/ansible/requirements.yml
ONBUILD RUN ansible-galaxy collection install -r /workspace/ansible/requirements.yml

FROM base AS talos-bootstrap

WORKDIR /workspace/kubernetes/scripts

RUN mkdir -p /root/.talos /root/.kube

FROM base AS runtime

RUN mkdir -p /root/.talos /root/.kube

WORKDIR /workspace

CMD ["/bin/bash"]
