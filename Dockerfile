FROM node:20.20.2-bookworm-slim AS builder

WORKDIR /app

ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0
ENV HUSKY=0

RUN corepack enable

COPY . .

RUN yarn install --immutable
RUN yarn workspace examples.tldraw.com build

FROM node:20.20.2-bookworm-slim AS runtime

WORKDIR /app

ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0
ENV NODE_ENV=production

RUN corepack enable && corepack prepare yarn@4.12.0 --activate
RUN printf 'nodeLinker: node-modules\n' > .yarnrc.yml
RUN printf '{"private":true,"dependencies":{}}\n' > package.json
RUN yarn add vite@8.0.8 @vitejs/plugin-react@6.0.1 cos-nodejs-sdk-v5@2.15.4 remark@15.0.1 remark-frontmatter@5.0.0 remark-html@16.0.1 vfile-matter@5.0.0

COPY --from=builder /app/apps/examples/dist ./apps/examples/dist
COPY --from=builder /app/apps/examples/public ./apps/examples/public
COPY apps/examples/vite.config.ts ./apps/examples/vite.config.ts

EXPOSE 5420

CMD ["yarn", "vite", "preview", "--config", "apps/examples/vite.config.ts", "--host", "0.0.0.0"]
