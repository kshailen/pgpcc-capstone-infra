#!/usr/bin/env bash
sudo yum -y update
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
sudo systemctl status httpd
