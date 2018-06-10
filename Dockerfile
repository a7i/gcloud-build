FROM google/cloud-sdk:203.0.0-alpine

ENV HELM_VERSION "v2.9.1"
ENV PATH /google-cloud-sdk/bin:$PATH

RUN apk --no-cache add \
        curl \
        python \
        py-crcmod \
        bash \
        libc6-compat \
        openrc \
        openssh-client \
        ca-certificates \
        openssl \
        git \
        docker \
    && gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud config set metrics/environment github_docker_image && \
    gcloud --quiet components install kubectl --no-user-output-enabled && \
    rc-update add docker boot && \
    rc-update add local boot && \
    echo 'rc_env_allow="GOOGLE_AUTH GCLOUD_PROJECT_ID GCLOUD_COMPUTE_ZONE GCLOUD_CLUSTER_NAME HOME"' >> /etc/rc.conf && \
    echo 'rc_verbose=yes' >> /etc/conf.d/local && \
    curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh && chmod 700 get_helm.sh && \
    ./get_helm.sh --version $HELM_VERSION && \
    helm init --client-only && \
    rm get_helm.sh && \
    rm -rf /var/cache/apk/*