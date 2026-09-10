FROM node:22-bookworm-slim AS build

WORKDIR /opt/app

COPY package*.json ./
RUN npm ci

COPY . .

ENV NODE_ENV=production

RUN npm run build
RUN npm prune --omit=dev


FROM node:22-bookworm-slim

WORKDIR /opt/app

ENV NODE_ENV=production

COPY --from=build /opt/app ./

RUN mkdir -p /opt/app/public/uploads \
    && chown -R node:node /opt/app

USER node

EXPOSE 1337

CMD ["npm", "run", "start"]