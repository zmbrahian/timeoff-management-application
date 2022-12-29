from mysql as base
COPY ./mysql-init/ /docker-entrypoint-initdb.d/