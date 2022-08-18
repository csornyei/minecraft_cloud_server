#!/bin/sh
bucket="csornyei-minecraft-server"

file=/home/ubuntu/minecraft_server.zip

/usr/bin/zip -r ${file} /home/ubuntu/minecraft_server

/usr/local/bin/aws s3 mv "${file}" "s3://${bucket}"