FROM node:6.10.3-alpine

RUN apk --update --upgrade add git

RUN git clone https://github.com/billchurch/WebSSH2.git

WORKDIR /WebSSH2

RUN npm install --production

EXPOSE 2222/tcp

COPY . .

CMD ["npm", "start"]
