# hubot-firebase-brain
A hubot script to persist hubot's brain using firebase - because, why not?

## Installation

Add `hubot-firebase-brain` to your package.json with  `npm install hubot-firebase-brain --save`.

```
"dependencies": {
  "hubot-firebase-brain": ">= 1.0.0"
}
```

Add `hubot-firebase-brain` to `external-scripts.json`.

```
> cat external-scripts.json
> ["hhubot-firebase-brain"]
```

## Configuration
Set the enviornment variable `FIREBASE_URL` to your firebase/hubot scope. eg https://your_firebase.firebaseio.com/hubot


## (Optional) Firebase Authentication
Set the enviornment variable `FIREBASE_SECRET` generated here from Firebase (https://your_firebase.firebaseio.com/?page=Admin)

Create a security rule to allow read/write. Simply add `auth.hubot === true` to the scope of your hubot firebase. (https://your_firebase.firebaseio.com/?page=Security). 

```
{
    "rules": {
        "hubot": {
          ".read": "auth.hubot === true",
          ".write": "auth.hubot === true"
        }
    }
}
```
