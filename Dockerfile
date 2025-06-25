# Use the official code-server image as base
FROM codercom/code-server:latest

# Set environment variables
ENV USER=coder
ENV PASSWORD=waluka  # Set empty password by default (use docker secrets for production)
ENV SHELL=/bin/bash
ENV DOCKER_USER=${USER}
ENV HOME=/home/coder

# Install additional system packages
RUN sudo apt-get update && \
    sudo apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    wget \
    git \
    git-lfs \
    zsh \
    fish \
    vim \
    nano \
    htop \
    net-tools \
    python3 \
    python3-pip \
    python3-venv \
    nodejs \
    npm \
    yarn \
    jq \
    rsync \
    openssh-client \
    && sudo apt-get clean && \
    sudo rm -rf /var/lib/apt/lists/*

# Install Docker CLI (for Docker-in-Docker setups)
RUN curl -fsSL https://get.docker.com | sh && \
    sudo usermod -aG docker ${USER}

# Install common development tools
RUN sudo npm install -g \
    typescript \
    eslint \
    prettier \
    @angular/cli \
    create-react-app \
    vue-cli \
    nodemon \
    && sudo npm cache clean --force

# Install Python tools
RUN sudo pip3 install --no-cache-dir --upgrade \
    pip \
    setuptools \
    wheel \
    virtualenv \
    pylint \
    black \
    flake8 \
    pytest \
    ipython \
    jupyter

# Install VS Code extensions
RUN code-server --install-extension \
    ms-python.python \
    ms-vscode.vscode-typescript-next \
    esbenp.prettier-vscode \
    dbaeumer.vscode-eslint \
    eamodio.gitlens \
    vscodevim.vim \
    ritwickdey.liveserver \
    ms-azuretools.vscode-docker \
    redhat.vscode-yaml \
    hashicorp.terraform \
    golang.go \
    rust-lang.rust \
    dart-code.dart-code \
    dart-code.flutter \
    ms-toolsai.jupyter \
    shd101wyy.markdown-preview-enhanced

# Configure workspace settings
COPY --chown=${USER}:${USER} settings.json /home/coder/.local/share/code-server/User/settings.json

# Set up workspace directory
WORKDIR /home/coder/project

# Expose code-server port
EXPOSE 8080

# Start code-server
ENTRYPOINT ["dumb-init", "--"]
CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "--auth", "none", "--disable-telemetry"]
