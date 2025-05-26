#!/bin/bash
# Define a senha do root a partir da variável de ambiente ROOT_PASSWORD
if [ -n "$ROOT_PASSWORD" ]; then
    echo "root:$ROOT_PASSWORD" | chpasswd
else
    echo "AVISO: Nenhuma senha para root definida (variável ROOT_PASSWORD não configurada)."
fi

# Inicia o SSH Server em foreground
/usr/sbin/sshd -D
