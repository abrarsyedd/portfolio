# Dockerfile (app)
FROM node:18-alpine

WORKDIR /usr/src/app

# copy package metadata first to leverage Docker cache for installs
COPY package*.json ./
RUN npm ci --only=production

# copy source
COPY . .

ENV NODE_ENV=production
EXPOSE 3000

CMD ["node", "server.js"]
