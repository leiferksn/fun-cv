FROM node:22-alpine AS build

WORKDIR /app

COPY . .

COPY nginx.template /nginx.template

RUN chmod +x /app/entrypoint.sh

# Serve Application using Nginx Server
FROM nginx:alpine

ARG SSL_CERT
ARG SSL_KEY

COPY --from=build /app/index.html /usr/share/nginx/html
COPY --from=build /nginx.template /etc/nginx/nginx.template

COPY --from=build /app/entrypoint.sh /entrypoint.sh

RUN ls -l /entrypoint.sh \ 
	&& chmod +x /entrypoint.sh


ENV SSL_CERT=${SSL_CERT}
ENV SSL_KEY=${SSL_KEY}

EXPOSE 80 443
ENTRYPOINT ["/entrypoint.sh"]
