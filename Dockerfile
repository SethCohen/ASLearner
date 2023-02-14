# Install Operating System
FROM ubuntu:20.04 AS build-env

# Disable interactive mode 
ENV DEBIAN_FRONTEND noninteractive

# Prerequisites
RUN apt-get update 
RUN apt-get install -y curl git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback lib32stdc++6 python3 sed
RUN apt-get clean

# Download Flutter SDK from Flutter Github repo
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

# Set Flutter environment path
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Run flutter doctor
RUN flutter doctor

# Enable flutter web
RUN flutter channel master
RUN flutter upgrade
RUN flutter config --enable-web

# Copy files to container and build
RUN mkdir /app/
COPY . /app/
WORKDIR /app/src/
RUN flutter build web

# Create the run-time image
FROM nginx:1.21.1-alpine
COPY --from=build-env /app/src/build/web /usr/share/nginx/html
