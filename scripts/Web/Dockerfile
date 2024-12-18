# Create and extract the configurations files for nginx servers
FROM ubuntu as build

WORKDIR /app/

RUN mkdir appfiles

COPY frontend.tar default.conf.template ./

# Extract the new configurations for nginx
RUN tar xvf frontend.tar -C appfiles/ && \
    sed -i 's/${[A-Z]\+_HOST}/localhost/g' default.conf.template

# Configure nginx server
FROM nginx:alpine as SERVER

# Copy nginx configuration, html artifacts from build stage
COPY --from=build /app/default.conf.template /etc/nginx/conf.d/
COPY --from=build /app/appfiles/* /usr/share/nginx/html/

# Remove default configuration and include new configuration
RUN rm /etc/nginx/conf.d/default.conf  && \
    echo "include /etc/nginx/conf.d/* ;" | cat  >  /etc/nginx/nginx.conf

# Expose HTTPS port
EXPOSE 8080

