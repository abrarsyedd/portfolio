FROM node:18-alpine

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm ci --only=production

COPY . .

ENV NODE_ENV=production
EXPOSE 3000

# Use wait-for-it to ensure DB is ready
COPY wait-for-it.sh /usr/src/app/wait-for-it.sh
RUN chmod +x wait-for-it.sh

CMD ["./wait-for-it.sh", "db:3306", "--", "node", "server.js"]

