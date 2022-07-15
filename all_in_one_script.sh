#!/bin/bash

#Update
apt-get update


#Install React Web App and autolaunch on reboot
curl -sL https://deb.nodesource.com/setup_14.x | sudo bash -
apt -y install nodejs
npx create-react-app /home/ubuntu/my-app
npm run build --prefix /home/ubuntu/my-app
npm install -g serve
npm install -g pm2
pm2 serve /home/ubuntu/my-app/build 3000 --spa
pm2 save
pm2 startup

mkdir /var/log/tcpdumpd
#Write configuration file for tcpdump daemon
touch /etc/systemd/system/sniffer.service
echo '[Unit]
After=network.target
[Service]
Restart=always
RestartSec=30
ExecStartPre=/bin/mkdir -p /var/log/tcpdumpd/
ExecStart=/usr/bin/tcpdump -s 0 -A "tcp[((tcp[12:1] & 0xf0) >> 2):4] = 0x47455420"
ExecStop=/bin/kill -s QUIT $MAINPID
StandardOutput=file:/var/log/tcpdumpd/log1.log
[Install]
WantedBy=multi-user.target' > /etc/systemd/system/sniffer.service

#Enable daemon and autolaunch on startup
systemctl daemon-reload
systemctl start sniffer.service
systemctl enable sniffer.service

#Install and configure Cloudwatch agent
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
dpkg -i -E ./amazon-cloudwatch-agent.deb
echo '{
      "agent": {
        "run_as_user":"root"
      },
      "logs": {
        "logs_collected": {
          "files": {
            "collect_list": [
              {
                "file_path": "/var/log/tcpdumpd/log1.log",
                "log_group_name": "tcpdump-${instance_identifier}",
                "log_stream_name": "${instance_identifier}"
              }
            ]
          }
       }
    }
}' > /opt/aws/amazon-cloudwatch-agent/bin/config.json
#Launch agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s
