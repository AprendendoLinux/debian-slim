# Projeto Debian Slim - Ambiente Docker com SSH

Bem-vindo ao repositório [AprendendoLinux/debian-slim](https://github.com/AprendendoLinux/debian-slim/)! Este projeto configura um contêiner Docker baseado na imagem `debian:12-slim`, projetado para fornecer um ambiente Linux leve, seguro e configurável com suporte a SSH, ferramentas de rede e desenvolvimento, e um diretório mapeado para compartilhamento de arquivos. É ideal para testes, desenvolvimento, administração de sistemas, ou aprendizado de Linux em um ambiente isolado.

## Sumário
- [Visão Geral](#visão-geral)
- [Funcionalidades Principais](#funcionalidades-principais)
- [Pré-requisitos](#pré-requisitos)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Configuração do Ambiente](#configuração-do-ambiente)
  - [Variáveis de Ambiente](#variáveis-de-ambiente)
  - [Volumes](#volumes)
  - [Portas](#portas)
- [Como Usar](#como-usar)
  - [Clonando o Repositório](#clonando-o-repositório)
  - [Construindo a Imagem](#construindo-a-imagem)
  - [Executando o Contêiner com Docker Compose](#executando-o-contêiner-com-docker-compose)
  - [Acessando o Contêiner via SSH](#acessando-o-contêiner-via-ssh)
- [Ferramentas Instaladas](#ferramentas-instaladas)
- [Estrutura dos Arquivos](#estrutura-dos-arquivos)
- [Exemplos de Uso](#exemplos-de-uso)
  - [Sincronização de Arquivos com rsync](#sincronização-de-arquivos-com-rsync)
  - [Testes de Rede com tcpdump](#testes-de-rede-com-tcpdump)
  - [Conexão a Banco de Dados MariaDB](#conexão-a-banco-de-dados-mariadb)
- [Boas Práticas](#boas-práticas)
- [Segurança](#segurança)
- [Personalização](#personalização)
- [Solução de Problemas](#solução-de-problemas)
- [FAQ](#faq)
- [Contribuições](#contribuições)
- [Licença](#licença)
- [Agradecimentos](#agradecimentos)

## Visão Geral
O projeto `debian-slim` cria um contêiner Docker baseado na imagem `debian:12-slim`, configurado com um servidor SSH para acesso remoto seguro. Ele permite personalizar a senha do usuário `root`, configurar o fuso horário, e mapear um diretório local para `/var/www/html` no contêiner, facilitando o compartilhamento de arquivos entre o host e o contêiner. O ambiente inclui ferramentas essenciais para administração de sistemas, diagnósticos de rede, e desenvolvimento, como `git`, `vim`, `tcpdump`, `rsync`, e `mariadb-client`.

O repositório utiliza um `Dockerfile` para construir a imagem, um script `entrypoint.sh` para inicializar o contêiner, e um arquivo `docker-compose.yml` para simplificar a execução e configuração do serviço.

## Funcionalidades Principais
- **Acesso SSH**: Conexão segura ao contêiner via SSH com autenticação por senha.
- **Ambiente Leve**: Baseado em `debian:12-slim` para minimizar o tamanho da imagem.
- **Ferramentas de Rede e Desenvolvimento**: Inclui `tcpdump`, `net-tools`, `iputils-ping`, `telnet`, `git`, `vim`, e mais.
- **Configuração Flexível**: Suporte a variáveis de ambiente para senha do root e fuso horário.
- **Volume Mapeado**: Diretório `/var/www/html` para compartilhamento de arquivos.
- **Reinicialização Automática**: Configurado para reiniciar automaticamente em caso de falha.

## Pré-requisitos
Para usar este projeto, você precisa ter instalado:
- [Docker](https://www.docker.com/get-started) (versão 20.10 ou superior recomendada).
- [Docker Compose](https://docs.docker.com/compose/install/) (versão 2.0 ou superior recomendada).
- Um cliente SSH (ex.: `OpenSSH` no Linux/Mac, `PuTTY` no Windows, ou qualquer terminal compatível).
- [Git](https://git-scm.com/downloads) (opcional, para clonar o repositório).
- Pelo menos 512 MB de RAM disponíveis para o contêiner.
- Espaço em disco para o diretório mapeado `/srv/acesso`.

## Estrutura do Projeto
O repositório contém os seguintes arquivos:
- `Dockerfile`: Define a construção da imagem Docker.
- `docker-compose.yml`: Configura o serviço do contêiner com variáveis de ambiente, volumes e portas.
- `entrypoint.sh`: Script que define a senha do root e inicia o servidor SSH.

## Configuração do Ambiente

### Variáveis de Ambiente
O contêiner suporta as seguintes variáveis de ambiente, definidas no `docker-compose.yml`:
- `ROOT_PASSWORD`: Define a senha do usuário `root` para acesso SSH. **Recomenda-se usar uma senha forte**. Exemplo: `Sua_Senha_Segura`.
- `TZ`: Define o fuso horário do contêiner. Exemplo: `America/Sao_Paulo`.

**Aviso**: Se `ROOT_PASSWORD` não for definida, o contêiner emitirá um aviso no log, mas ainda será iniciado. Nesse caso, o login SSH pode não ser possível até que uma senha seja configurada.

### Volumes
O contêiner mapeia o diretório local `/srv/acesso` para `/var/www/html` no contêiner. Isso permite:
- Compartilhar arquivos entre o host e o contêiner.
- Persistir dados mesmo após o contêiner ser reiniciado.
Certifique-se de criar o diretório `/srv/acesso` no host antes de iniciar o contêiner:
```bash
mkdir -p /srv/acesso
```

### Portas
O serviço mapeia a porta `2222` no host para a porta `22` (SSH) no contêiner. Isso permite acessar o contêiner via SSH usando `localhost:2222`. A porta pode ser alterada no `docker-compose.yml` se necessário.

## Como Usar

### Clonando o Repositório
1. Clone o repositório do GitHub:
   ```bash
   git clone https://github.com/AprendendoLinux/debian-slim.git
   cd debian-slim
   ```

### Construindo a Imagem
1. Certifique-se de que os arquivos `Dockerfile`, `docker-compose.yml` e `entrypoint.sh` estão no diretório atual.
2. Construa a imagem Docker:
   ```bash
   docker build -t aprendendolinux/debian:latest .
   ```
   Isso criará a imagem com o nome `aprendendolinux/debian:latest`.

### Executando o Contêiner com Docker Compose
1. Edite o arquivo `docker-compose.yml` para definir a variável `ROOT_PASSWORD` com uma senha segura.
2. (Opcional) Ajuste a variável `TZ` para o fuso horário desejado (ex.: `America/Sao_Paulo`).
3. Inicie o contêiner:
   ```bash
   docker-compose up -d
   ```
   O contêiner será iniciado em modo *detached* (em segundo plano). Para verificar se está rodando:
   ```bash
   docker ps
   ```

### Acessando o Contêiner via SSH
1. Conecte-se ao contêiner via SSH:
   ```bash
   ssh root@localhost -p 2222
   ```
2. Insira a senha definida em `ROOT_PASSWORD`.

**Nota**: Certifique-se de que a porta `2222` não está em uso por outro serviço no host. Use `netstat -tuln | grep 2222` para verificar.

## Ferramentas Instaladas
O contêiner inclui as seguintes ferramentas, instaladas via `apt-get`:
- **openssh-server**: Servidor SSH para acesso remoto.
- **rsync**: Sincronização de arquivos entre sistemas.
- **sshpass**: Automação de login SSH (útil para scripts).
- **mariadb-client**: Cliente para conexão a bancos de dados MariaDB/MySQL.
- **tzdata**: Suporte a configuração de fuso horário.
- **git**: Controle de versão para projetos.
- **net-tools**: Ferramentas de rede como `ifconfig` e `netstat`.
- **iputils-ping**: Ferramenta `ping` para testes de conectividade.
- **telnet**: Cliente para testes de conexão em portas específicas.
- **tcpdump**: Captura e análise de pacotes de rede.
- **vim**: Editor de texto avançado.

## Estrutura dos Arquivos

### `Dockerfile`
- **Base**: Usa `debian:12-slim` para um ambiente leve e eficiente.
- **Instalação de Pacotes**: Instala dependências listadas e limpa o cache do `apt` para reduzir o tamanho da imagem.
- **Configuração do SSH**: Habilita login do root e autenticação por senha no arquivo `/etc/ssh/sshd_config`.
- **TimeZone**: Configura o fuso horário com base na variável `TZ`, usando `dpkg-reconfigure`.
- **Volume**: Cria o diretório `/var/www/html` para mapeamento de arquivos.
- **Entrypoint**: Executa o script `entrypoint.sh` ao iniciar o contêiner.

### `docker-compose.yml`
- Define o serviço `acesso` com:
  - Nome do contêiner: `acesso`.
  - Hostname: `acesso`.
  - Imagem: `aprendendolinux/debian:latest`.
  - Política de reinicialização: `always`.
  - Variáveis de ambiente: `ROOT_PASSWORD` e `TZ`.
  - Volume: Mapeia `/srv/acesso` para `/var/www/html`.
  - Porta: Mapeia `2222:22`.

### `entrypoint.sh`
- Configura a senha do root com base na variável `ROOT_PASSWORD` usando `chpasswd`.
- Emite um aviso se `ROOT_PASSWORD` não estiver definida.
- Inicia o servidor SSH em modo *foreground* com `/usr/sbin/sshd -D`.

## Exemplos de Uso

### Sincronização de Arquivos com rsync
Use o `rsync` para sincronizar arquivos entre o diretório mapeado `/srv/acesso` no host e outro servidor remoto:
1. Acesse o contêiner via SSH:
   ```bash
   ssh root@localhost -p 2222
   ```
2. Execute o comando `rsync`:
   ```bash
   rsync -avz /var/www/html/ usuario@servidor_remoto:/destino/
   ```
   Isso sincroniza os arquivos de `/var/www/html` para o servidor remoto.

### Testes de Rede com tcpdump
Capture pacotes de rede para análise:
1. Acesse o contêiner via SSH.
2. Execute:
   ```bash
   tcpdump -i eth0 -w captura.pcap
   ```
   Isso captura pacotes na interface `eth0` e salva em `captura.pcap` no diretório `/var/www/html`, acessível no host em `/srv/acesso`.

### Conexão a Banco de Dados MariaDB
Conecte-se a um banco de dados MariaDB/MySQL remoto:
1. Acesse o contêiner via SSH.
2. Use o cliente `mariadb`:
   ```bash
   mariadb -h host_do_banco -u usuario -p
   ```
   Insira a senha quando solicitado.

## Boas Práticas
- **Use Senhas Fortes**: Defina uma senha complexa em `ROOT_PASSWORD` para evitar acessos não autorizados.
- **Restrinja Acesso SSH**: Considere configurar chaves SSH em vez de senhas para maior segurança (veja a seção [Segurança](#segurança)).
- **Monitore Logs**: Verifique os logs do contêiner regularmente com `docker-compose logs acesso` para identificar problemas.
- **Mantenha o Diretório `/srv/acesso` Seguro**: Evite armazenar dados sensíveis diretamente no diretório mapeado sem proteção.
- **Atualize Regularmente**: Reconstrua a imagem periodicamente para incluir atualizações de segurança do Debian.

## Segurança
- **SSH Seguro**:
  - Considere desativar a autenticação por senha e usar chaves SSH. Edite o `Dockerfile` para incluir sua chave pública em `/root/.ssh/authorized_keys` e desative `PasswordAuthentication` no `/etc/ssh/sshd_config`.
  - Exemplo:
    ```bash
    RUN echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
    ```
- **Firewall**: Configure um firewall no host para restringir o acesso à porta `2222` a IPs confiáveis.
- **Senhas**: Evite expor `ROOT_PASSWORD` em repositórios públicos ou logs. Use ferramentas como `docker-compose.yml` com arquivos `.env` para maior segurança.
- **Permissões do Volume**: Defina permissões restritivas no diretório `/srv/acesso` (ex.: `chmod 700 /srv/acesso`).

## Personalização
- **Mudar a Senha do Root**: Edite `ROOT_PASSWORD` no `docker-compose.yml`.
- **Alterar o Fuso Horário**: Modifique `TZ` no `docker-compose.yml` (ex.: `Europe/Lisbon`).
- **Adicionar Pacotes**: Inclua pacotes adicionais no `Dockerfile` no comando `apt-get install`.
- **Mudar a Porta SSH**: Ajuste o mapeamento de portas no `docker-compose.yml` (ex.: `"3333:22"`).
- **Adicionar Usuários**: Modifique o `entrypoint.sh` para criar usuários adicionais:
  ```bash
  useradd -m -s /bin/bash novo_usuario
  echo "novo_usuario:sua_senha" | chpasswd
  ```

## Solução de Problemas
- **Erro de conexão SSH**:
  - Verifique se a porta `2222` está em uso: `netstat -tuln | grep 2222`.
  - Confirme que `ROOT_PASSWORD` está definida corretamente.
  - Veja os logs: `docker-compose logs acesso`.
- **Contêiner não inicia**:
  - Verifique se o diretório `/srv/acesso` existe: `ls -ld /srv/acesso`.
  - Confirme que a imagem foi construída: `docker images | grep aprendendolinux`.
- **Timezone incorreto**:
  - Verifique a variável `TZ` no `docker-compose.yml`.
  - Reinicie o contêiner: `docker-compose restart`.
- **Espaço em disco insuficiente**:
  - Libere espaço no host ou aumente o tamanho do volume `/srv/acesso`.
- **Permissões no volume**:
  - Ajuste permissões no host: `chmod -R 755 /srv/acesso`.

## FAQ
**P: Posso usar este contêiner em produção?**  
R: Este contêiner é otimizado para desenvolvimento e testes. Para produção, implemente medidas adicionais de segurança, como chaves SSH, firewall, e monitoramento.

**P: Como adiciono mais ferramentas ao contêiner?**  
R: Edite o `Dockerfile`, adicione os pacotes desejados ao comando `apt-get install`, e reconstrua a imagem com `docker build`.

**P: Posso mudar a porta SSH?**  
R: Sim, altere o mapeamento de portas no `docker-compose.yml` (ex.: `"8080:22"`) e reinicie o contêiner.

**P: Por que o contêiner usa `debian:12-slim`?**  
R: A imagem `debian:12-slim` é leve, reduzindo o tamanho do contêiner e o consumo de recursos, enquanto mantém as funcionalidades essenciais do Debian.

**P: Como acesso os arquivos em `/var/www/html`?**  
R: Os arquivos em `/var/www/html` no contêiner são mapeados para `/srv/acesso` no host. Acesse-os diretamente no host ou via SSH no contêiner.

## Contribuições
Contribuições são muito bem-vindas! Para contribuir:
1. Faça um fork do repositório: [https://github.com/AprendendoLinux/debian-slim/](https://github.com/AprendendoLinux/debian-slim/).
2. Crie uma branch para sua feature: `git checkout -b minha-feature`.
3. Faça commit das alterações: `git commit -m "Adiciona minha feature"`.
4. Envie para o repositório remoto: `git push origin minha-feature`.
5. Abra um Pull Request no GitHub.

Por favor, siga as diretrizes de código e inclua testes ou documentação para suas alterações.

## Licença
Este projeto está licenciado sob a [MIT License](LICENSE). Veja o arquivo `LICENSE` para mais detalhes (se aplicável).

## Agradecimentos
- À comunidade [AprendendoLinux](https://github.com/AprendendoLinux) por promover o aprendizado de Linux.
- Aos desenvolvedores do Docker e Debian por fornecerem ferramentas incríveis.
- A todos os contribuidores que ajudarem a melhorar este projeto!