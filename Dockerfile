FROM node:22-alpine AS build

WORKDIR /app

COPY . .

COPY nginx.template /nginx.template

RUN chmod +x /app/entrypoint.sh

# Serve Application using Nginx Server
FROM nginx:alpine

ARG root_path 

ENV ROOT_PATH=${root_path}

COPY --from=build /app/index.html $ROOT_PATH 
COPY --from=build /nginx.template /etc/nginx/nginx.template

COPY --from=build /app/entrypoint.sh /entrypoint.sh

RUN ls -l /entrypoint.sh \ 
	&& chmod +x /entrypoint.sh


EXPOSE 80 443
ENTRYPOINT ["/entrypoint.sh"]
