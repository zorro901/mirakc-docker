FROM mirakc/mirakc:3.2.7-debian
LABEL authors="user"

# 必要なパッケージのインストールとダウンロード＆インストールを1つのRUNにまとめる
RUN apt-get update && \
    apt-get install -yq pcsc-tools pcscd wget curl && \
    wget https://github.com/kazuki0824/recisdb-rs/releases/download/1.2.2/recisdb_1.2.2-1_amd64.deb && \
    apt-get install -y ./recisdb_1.2.2-1_amd64.deb && \
    curl -L -o libaribb25_0.2.9_amd64.deb https://github.com/tsukumijima/libaribb25/releases/download/v0.2.9/libaribb25_0.2.9_amd64.deb && \
    apt-get install -y ./libaribb25_0.2.9_amd64.deb && \
    rm recisdb_1.2.2-1_amd64.deb libaribb25_0.2.9_amd64.deb && \
    apt-get clean && \
    systemctl enable pcscd

# services.sh をコピーして実行権限を付与し、改行を修正
COPY --chmod=755 services.sh /usr/local/bin/services.sh

# ポートとボリュームの定義
EXPOSE 40772
VOLUME /var/lib/mirakc/epg

# ENTRYPOINTでスクリプトを実行
ENTRYPOINT ["/bin/bash", "/usr/local/bin/services.sh"]
CMD []