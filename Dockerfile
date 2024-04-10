ARG NODE_VERSION=20.8
ARG YARN_VERSION=3.6.1
ARG REDIS_URL="redis://redis:6379"
ARG PORT=8080

FROM node:${NODE_VERSION}-slim as base
ARG REDIS_URL

ENV REDIS_URL=${REDIS_URL}
ENV NODE_ENV=production
ENV NUXT_TELEMETRY_DISABLED=1

RUN yarn set version ${YARN_VERSION}
WORKDIR /src

# Build
FROM base as build

COPY . ./
RUN yarn add -W nuxt \
    && yarn \
    && yarn build

# Run
FROM base
ARG PORT
ARG REDIS_URL

ENV PORT=$PORT
ENV REDIS_URL=${REDIS_URL}
ENV NODE_ENV=production
ENV NUXT_TELEMETRY_DISABLED=1

COPY --from=build /src/.output ./

# Expose both ports
EXPOSE $PORT

# Specify the command to run your app
CMD [ "node", "/src/server/index.mjs" ]
