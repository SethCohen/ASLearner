# ASLearner [![Website](https://img.shields.io/website?label=aslearner.apps.science.ontariotechu.ca&style=for-the-badge&url=https%3A%2F%2Faslearner.apps.science.ontariotechu.ca)](https://aslearner.apps.science.ontariotechu.ca/)

An American Sign Language Learning app.

## Contributing, Selh-Hosting, and Deploying

### Setting everything up

1. [Fork the repository.](https://github.com/SethCohen/ASLearner/fork)
2. [Create and setup your own Firebase project.](https://firebase.google.com/docs/web/setup)
3. Configure Flutter for Firebase Web
   1. `$ cd src`
   2. `$ firebase login`
   3. `$ dart pub global activate flutterfire_cli`
4. [Setup Firestore](https://firebase.google.com/docs/firestore/quickstart) and add some sample data with the following structure.

    1. ```yaml
        decks/
            <deckId>
                cardCount: int
                description: string
                title: string
                cards/
                    <cardId>
                        image: string
                        instructions: string
                        title: string
                        type: string="immutable"
        users/
        ```

5. [Setup Google Sign In Web](https://pub.dev/packages/google_sign_in_web#usage)
   1. Edit `src/web/index.html` and replace `<meta name="google-signin-client_id" content="YOUR_GOOGLE_SIGN_IN_CLIENT_ID_HERE.apps.googleusercontent.com">`.

### Running the project

#### Debugging

1. `$ flutter run -d chrome --web-hostname localhost --web-port 7357`

#### Deploying using docker

1. Create a `.env` file

```yaml
PROJECT_ID="YOUR_FIREBASE_PROJECT_ID_HERE"
FIREBASE_TOKEN="YOUR_FIREBASE_TOKEN_HERE" # Generated from $ firebase login:ci
```

2. `$ docker compose build`
3. Run the container with `$ docker compose up -d`
4. Go to `http://localhost:7357/` in browser.

### Contributing

1. Make your changes.
2. Follow [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) standard.
3. Submit a pull request.
