# Browser-only server image. See docs/browser-server.md.
FROM node:26-bookworm-slim AS build
WORKDIR /src
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run plugins:setup \
 && npm run build \
 && node scripts/build-server.mjs

FROM node:26-bookworm-slim
RUN apt-get update \
 && apt-get install -y --no-install-recommends chromium fonts-noto-core fonts-noto-color-emoji ca-certificates tini \
 && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY --from=build --chown=node:node /src/.next/standalone ./
ENV NODE_ENV=production \
    HOSTNAME=0.0.0.0 \
    PORT=3000 \
    LH_DATA_DIR=/data/data \
    LH_AUTH_FILE=/data/auth.json \
    CHROME_PATH=/usr/bin/chromium
RUN mkdir -p /data && chown node:node /data
USER node
VOLUME /data
EXPOSE 3000
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["node", "server.js"]
