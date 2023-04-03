# Install Operating System
FROM ubuntu:20.04 AS build-env

# Set build arguments
ARG PROJECT_ID
ARG FIREBASE_TOKEN

# Disable interactive mode 
ENV DEBIAN_FRONTEND noninteractive

# Prerequisites
RUN apt-get update 
RUN apt-get install -y curl git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback lib32stdc++6 python3 sed sudo
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

# Copy files to container and set working directory 
RUN mkdir /app/
COPY . /app/
WORKDIR /app/src/

# Get Firebase CLI
RUN curl -sL https://firebase.tools | bash

# Setup FlutterFire
RUN dart pub global activate flutterfire_cli
ENV PATH="/root/.pub-cache/bin:${PATH}"
RUN flutterfire configure -t ${FIREBASE_TOKEN} -p ${PROJECT_ID} -y

# Build Flutter Web
RUN flutter build web

# Create the run-time image
FROM nginx:1.21.1-alpine
COPY --from=build-env /app/src/build/web /usr/share/nginx/html
