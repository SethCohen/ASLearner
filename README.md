# asl

An ASL Learning app.

## How to run project

Debugging: `flutter run -d chrome --web-hostname localhost --web-port 7357`

Deploying:

1. Run `docker build . -t flutter_docker` in terminal.
2. Run `docker run --rm -d -p 7357:80/tcp flutter_docker:latest` in terminal.
3. Go to `http://localhost:7357/` in browser.

or alternatively

1. Run `flutter build web` in terminal.
2. Run `python -m http.server 7357` in terminal.
3. Go to `http://localhost:7357/build/web/` in browser.
