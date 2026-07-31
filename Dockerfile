ARG UBUNTU_VERSION=24.04
FROM ubuntu:${UBUNTU_VERSION}

# oh-my-posh のインストールとテーマ配置
RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates curl unzip python3 \
 && rm -rf /var/lib/apt/lists/* \
 && curl -fsSL https://ohmyposh.dev/install.sh | bash -s -- -d /usr/local/bin \
 && mkdir -p /usr/local/share/oh-my-posh/themes \
 && curl -fsSL https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/blueish.omp.json -o /tmp/blueish.omp.json \
 && python3 - <<'PY'
import json

source_path = "/tmp/blueish.omp.json"
target_path = "/usr/local/share/oh-my-posh/themes/gh-ubuntu.omp.json"

with open(source_path, encoding="utf-8") as source_file:
	config = json.load(source_file)

prompt_block = next(block for block in config["blocks"] if block.get("type") == "prompt" and block.get("alignment") == "left")
prompt_block["segments"].insert(
	2,
	{
		"background": "#546E7A",
		"foreground": "#26C6DA",
		"powerline_symbol": "\ue0b0",
		"style": "powerline",
		"template": " ubuntu {{ .Env.UBUNTU_VERSION }} ",
		"type": "text",
	},
)

with open(target_path, "w", encoding="utf-8") as target_file:
	json.dump(config, target_file, ensure_ascii=False, indent=2)
	target_file.write("\n")
PY

RUN { \
		echo ''; \
		echo '# Initialize oh-my-posh for interactive bash shells'; \
		echo 'if [[ $- == *i* ]] && command -v oh-my-posh >/dev/null 2>&1; then'; \
		echo '  eval "$(oh-my-posh init bash --config /usr/local/share/oh-my-posh/themes/gh-ubuntu.omp.json)"'; \
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
