# Build Stage
FROM node:18-alpine as build
WORKDIR /app
COPY package.json .
COPY package-lock.json .
RUN npm install
COPY . .
RUN npm run build

# Final Stage
FROM nginx:1.23.3-alpine
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
COPY --from=build /app/dist . 
ENTRYPOINT ["nginx", "-g", "daemon off;"]