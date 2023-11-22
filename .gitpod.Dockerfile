ARG FLUX_VERSION="2.1.2"
ARG HELM_VERSION="3.13.2"
ARG KUBECTL_VERSION="1.28.4"

FROM ghcr.io/fluxcd/flux-cli:v${FLUX_VERSION} AS flux
FROM alpine/helm:${HELM_VERSION} AS helm
FROM alpine/k8s:${KUBECTL_VERSION} AS kubectl

FROM gitpod/workspace-full

ENV NODE_VERSION="20.9.0"
ENV NPM_VERSION="10.1.0"
ENV GLOO_VERSION="1.15.16"
ENV AWS_DEFAULT_REGION="REGION"

# set node
RUN bash -c 'source $HOME/.nvm/nvm.sh && nvm install $NODE_VERSION \
    && nvm use $NODE_VERSION && nvm alias default $NODE_VERSION'
RUN echo "nvm use default &>/dev/null" >> ~/.bashrc.d/51-nvm-fix

# set npm
RUN npm install -g npm@$NPM_VERSION

# install aws cli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscli.zip" \
  && unzip awscli.zip \
  && sudo ./aws/install --update \
  && rm awscli.zip

# install glooctl
ADD https://github.com/solo-io/gloo/releases/download/v${GLOO_VERSION}/glooctl-linux-amd64 /usr/local/bin/glooctl
RUN sudo chmod +x /usr/local/bin/glooctl

# install flux
COPY --from=flux /usr/local/bin/flux /usr/local/bin/flux

# install kubectl
COPY --from=kubectl /usr/bin/kubectl /usr/local/bin/kubectl

# install aws-iam-authenticator
COPY --from=kubectl /usr/bin/aws-iam-authenticator /usr/local/bin/aws-iam-authenticator

# install helm
COPY --from=helm /usr/bin/helm /usr/local/bin/helm

# install kubent
COPY --from=ghcr.io/doitintl/kube-no-trouble:latest /app/kubent /usr/local/bin/kubent

# install k9s
COPY --from=derailed/k9s:latest /bin/k9s /usr/local/bin/k9s