# Usando a imagem base do Debian Slim
FROM debian:12-slim

# Atualizando pacotes e instalando dependências necessárias
RUN apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get install -y \
    openssh-server \
    rsync \
    sshpass \
    mariadb-client \
    tzdata \
    git \
    net-tools \
    iputils-ping \
    telnet \
    tcpdump \
    vim \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/* /tmp/*

# Configurando o TimeZone apenas se a variável TZ estiver definida
RUN if [ -n "$TZ" ]; then \
        echo "$TZ" > /etc/timezone && \
        ln -sf /usr/share/zoneinfo/$TZ /etc/localtime && \
        dpkg-reconfigure -f noninteractive tzdata; \
    fi

# Configurando o SSH para permitir login do root
RUN mkdir /var/run/sshd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Copia o script de entrada
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expondo a porta 22 para SSH
EXPOSE 22

# Criando um diretório para o volume mapeado
RUN mkdir -p /var/www/html

# Define Volume
VOLUME /var/www/html

# Definindo o diretório de trabalho
WORKDIR /root

# Iniciando o servidor SSH ao rodar o contêiner
ENTRYPOINT ["/entrypoint.sh"]
