ARG UBUNTU_VERSION=24.04
FROM ubuntu:${UBUNTU_VERSION}

# oh-my-posh のインストールとテーマ配置
RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates curl unzip \
 && rm -rf /var/lib/apt/lists/* \
 && curl -fsSL https://ohmyposh.dev/install.sh | bash -s -- -d /usr/local/bin \
 && mkdir -p /usr/local/share/oh-my-posh/themes \
 && curl -fsSL https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/blueish.omp.json -o /usr/local/share/oh-my-posh/themes/blueish.omp.json \
 && { \
			echo ''; \
			echo '# Initialize oh-my-posh for interactive bash shells'; \
			echo 'if [[ $- == *i* ]] && command -v oh-my-posh >/dev/null 2>&1; then'; \
			echo '  eval "$(oh-my-posh init bash --config /usr/local/share/oh-my-posh/themes/blueish.omp.json)"'; \
			echo 'fi'; \
		} >> /etc/bash.bashrc

# ubuntu ユーザーにsudo権限を付与
RUN mkdir -p /etc/sudoers.d \
 && echo "ubuntu ALL=NOPASSWD: ALL" > /etc/sudoers.d/ubuntu \
 && chmod 0440 /etc/sudoers.d/ubuntu

# エントリーポイントスクリプトの追加
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
