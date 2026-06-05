FROM ubuntu:latest

# ubuntu ユーザーにsudo権限を付与
RUN mkdir -p /etc/sudoers.d \
 && echo "ubuntu ALL=NOPASSWD: ALL" > /etc/sudoers.d/ubuntu \
 && chmod 0440 /etc/sudoers.d/ubuntu

# エントリーポイントスクリプトの追加
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
