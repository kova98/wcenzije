# Build Stage
FROM node:18-alpine as build
WORKDIR /app
COPY ./web/wcenzije/package.json .
COPY ./web/wcenzije/package-lock.json .
RUN npm install
COPY ./web/wcenzije .
RUN npm run build

# Final Stage
FROM nginx:1.23.3-alpine
COPY ./web/wcenzije/nginx.conf /etc/nginx/conf.d/default.conf
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
COPY --from=build /app/dist . 
ENTRYPOINT ["nginx", "-g", "daemon off;"]