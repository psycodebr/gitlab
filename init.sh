#!/bin/bash
# Script para corrigir problemas de sockets Unix e permissões após o GitLab iniciar

# Aguardar o GitLab iniciar completamente
echo "Aguardando o GitLab iniciar..."
until gitlab-ctl status | grep -q 'run: gitlab-rails: (pid'; do
  echo "GitLab ainda não está pronto, aguardando..."
  sleep 10
done

# Corrigir permissões do diretório de dados do GitLab
echo "Ajustando permissões..."
chown -R git:git /var/opt/gitlab
chmod -R 775 /var/opt/gitlab

# Verificar se o socket GitLab pode ser criado
echo "Verificando se o socket Unix está sendo criado corretamente..."
if ! [ -S /var/opt/gitlab/gitlab-rails/sockets ]; then
    echo "Criando o socket GitLab..."
    mkdir -p /var/opt/gitlab/gitlab-rails/sockets
    chown git:git /var/opt/gitlab/gitlab-rails/sockets
    chmod 775 /var/opt/gitlab/gitlab-rails/sockets
fi

# Realizar as migrações do banco de dados
echo "Executando migrações do banco de dados..."
gitlab-ctl reconfigure
gitlab-ctl restart

# Garantir que o GitLab está saudável
echo "Verificando estado do GitLab..."
gitlab-ctl status
