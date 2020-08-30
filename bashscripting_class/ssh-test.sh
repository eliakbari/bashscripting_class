#!/bin/bash

sshpass -v -f ./sshlogin sftp -oPort=1210 eli@localhost 'ls -l'
