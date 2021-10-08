#!/bin/bash

# 환경 변수와 함께 명령어 실행 시, 환경 변수 값으로 사용
version="${VERSION:-1.0.1}"
arch="${ARCH:-linux-amd64}"
bin_dir="${BIN_DIR:-/usr/local/bin}"


# node-exporter 파일 다운
wget "https://github.com/prometheus/node_exporter/releases/download/v$version/node_exporter-$version.$arch.tar.gz" \
    -O /data/node_exporter.tar.gz

mkdir -p /data/node_exporter

cd /data || { echo "ERROR! No /data found.."; exit 1; }

tar xfz /data/node_exporter.tar.gz -C /data/node_exporter || { echo "ERROR! Extracting the node_exporter tar"; exit 1; }


cp "/data/node_exporter/node_exporter-$version.$arch/node_exporter" "$bin_dir"
chown root "$bin_dir/node_exporter"
#
# 명령어 등록
cat <<EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Prometheus node exporter
[Service]
Type=simple
ExecStart=/usr/local/bin/node_exporter
[Install]
WantedBy=multi-user.target
EOF

##
# 서비스 실행
systemctl enable node_exporter.service
systemctl start node_exporter.service

echo "SUCCESS! Installation succeeded!"
