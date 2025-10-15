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

RUN uv tool install ansible-core --with boto3 --with botocore && \
    ansible --version

RUN ansible-galaxy collection install \
    amazon.aws \
    community.general

WORKDIR /workspace

FROM base AS ansible-deploy

WORKDIR /workspace

ONBUILD COPY ansible/requirements.yml /workspace/ansible/requirements.yml
ONBUILD RUN ansible-galaxy collection install -r /workspace/ansible/requirements.yml

FROM base AS runtime

WORKDIR /workspace

CMD ["/bin/bash"]
