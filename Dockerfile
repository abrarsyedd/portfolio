# Dockerfile (app)
FROM node:18-alpine

WORKDIR /usr/src/app

# install dependencies (production)
COPY package*.json ./
RUN npm ci --only=production

# copy app
COPY . .

ENV NODE_ENV=production
EXPOSE 3000

CMD ["node", "server.js"]
