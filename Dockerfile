FROM node:20.20.2-bookworm-slim

WORKDIR /app

ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0
ENV HUSKY=0

RUN corepack enable

COPY . .

RUN yarn install --immutable
RUN yarn workspace examples.tldraw.com build

EXPOSE 5420

CMD ["yarn", "workspace", "examples.tldraw.com", "dev", "--host", "0.0.0.0"]
