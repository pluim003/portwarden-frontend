# ---- Base Node ----
FROM alpine:3.5 AS base
# install node
RUN apk add --no-cache nodejs-current tini
# set working directory
WORKDIR /root/chat
# Set tini as entrypoint
ENTRYPOINT ["/sbin/tini", "--"]
# copy project file
COPY package.json .
 
#
# ---- Dependencies ----
FROM node:8.14.0-alpine AS release
# install node packages
RUN npm set progress=false && npm config set depth 0
COPY . .
RUN npm install
RUN npm build
EXPOSE 8000
CMD npm run start
 