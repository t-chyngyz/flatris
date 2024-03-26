FROM node:12 as builder
WORKDIR /usr/src/app
COPY package.json yarn.lock ./
RUN yarn --frozen-lockfile
COPY . ./
RUN yarn build

FROM alpine
RUN apk update && apk add yarn
WORKDIR /usr/src/app
COPY --from=builder /usr/src/app .
EXPOSE 3000
CMD yarn start
