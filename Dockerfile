FROM node:lts-alpine as builder
WORKDIR /app
ENV NODE_ENV=production
RUN  apk add --no-cache curl git && cd /tmp  # && \
RUN  curl -sf https://gobinaries.com/tj/node-prune # && \
RUN  mv -v node-prune /usr/local/bin && rm -rvf * && \
  echo "yarn cache clean && node-prune" > /usr/local/bin/node-clean && chmod +x /usr/local/bin/node-clean
ADD package.json package-lock.json ./
RUN npm install

ADD . ./
RUN npm run build

FROM node:lts-alpine
WORKDIR /app
ENV NODE_ENV=production
ADD package.json ./
ADD nuxt.config.js ./
COPY --from=builder ./app/node_modules ./node_modules/
COPY --from=builder ./app/.nuxt ./.nuxt/
COPY --from=builder ./app/static ./static/
ENV HOST 0.0.0.0
EXPOSE 8000
CMD ["yarn", "start"]
