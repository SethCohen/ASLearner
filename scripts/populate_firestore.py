import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import json
import os

# Gets the path to the service account file
currentDir = os.path.dirname(os.path.abspath(__file__))
serviceAccountPath = os.path.join(currentDir, 'serviceAccount.json')

# Initializes the Firebase Admin SDK
cred = credentials.Certificate(serviceAccountPath)
firebase_admin.initialize_app(cred)

# Initializes the Firestore client
db = firestore.client()

# # Delete all decks under db.collection(u'decks'):
# docs = db.collection(u'decks').get()
# for doc in docs:
#     doc.reference.delete()

# Gets the path to the data json file
dataPath = os.path.join(currentDir, 'data.json')

# Populates the Firestore database with the data from the json file
with open(dataPath) as f:
    data = json.load(f)
    
    batch = db.batch()
    
    # Creates deck
    for deck in data["lessons"]:
        deck_ref = db.collection(u'decks').document()
        batch.set(deck_ref, {
            u'title': deck["title"],
            u'description': deck["description"],
            u'cardCount': len(deck["cards"]),
        })
        
        # Creates cards
        for card in deck["cards"]:
            card_ref = deck_ref.collection(u'cards').document()
            batch.set(card_ref, {
                u'title': card["title"],
                u'instructions': card["instructions"],
                u'image': card["image"],
                u'type': "immutable",
            })
            
    batch.commit()