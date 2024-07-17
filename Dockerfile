# Define a imagem base, usando Python 3.11 com Alpine 3.18
FROM python:3.11.3-alpine3.18

# Mantenedor da imagem
LABEL maintainer="shtorachess9@gmail.com"

# Configurações para Python
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Copia os diretórios 'djangoapp' e 'scripts' para dentro do container
COPY djangoapp /djangoapp
COPY scripts /scripts

# Define o diretório de trabalho dentro do container
WORKDIR /djangoapp

# Expõe a porta 8000 para conexões externas (usada pelo Django)
EXPOSE 8000

# Instalação das dependências e configurações adicionais
RUN python -m venv /venv && \
    /venv/bin/pip install --upgrade pip && \
    /venv/bin/pip install -r /djangoapp/requirements.txt && \
    adduser --disabled-password --no-create-home duser && \
    mkdir -p /data/web/static /data/web/media && \
    chown -R duser:duser /venv /data/web && \
    chmod -R 755 /data/web && \
    chmod -R +x /scripts

# Adiciona o diretório '/scripts' e '/venv/bin' ao PATH do container
ENV PATH="/scripts:/venv/bin:$PATH"

# Define o usuário padrão para executar comandos dentro do container
USER duser

# Comando padrão para iniciar o container
CMD ["commands.sh"]
