# -------------------------------------------------------------------
# Minimal dockerfile from node:13-alpine base
#
# Instructions:
# =============
# 1. Create an empty directory and copy this file into it.
#
# 2. Create image with: 
#	docker build --tag timeoff:latest .
#
# 3. Run with: 
#	docker run -d -p 3000:3000 --name alpine_timeoff timeoff
#
# 4. Login to running container (to update config (vi config/app.json): 
#	docker exec -ti --user root alpine_timeoff /bin/sh
# --------------------------------------------------------------------
FROM node:13-alpine as dependencies

ENV NODE_ENV production

COPY ./package.json  .
RUN npm install 
RUN npm install mysql


FROM node:13-alpine

LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.docker.cmd="docker run -d -p 3000:3000 --name alpine_timeoff"

RUN adduser --system app --home /app
USER app
WORKDIR /app
COPY ./ /app
COPY --from=dependencies node_modules ./node_modules

ENV NODE_ENV production

CMD sleep 10 && npm start

EXPOSE 3000