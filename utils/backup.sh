#!/bin/sh
bucket="csornyeicom-minecraft-server"

file=/home/ubuntu/minecraft_server.zip

/usr/bin/zip -r ${file} minecraft_server

/usr/local/bin/aws s3 mv "${file}" "s3://${bucket}"