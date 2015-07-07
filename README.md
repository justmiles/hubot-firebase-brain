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
Set the enviornment variable `FIREBASE_URL` to your firebase/hubot scop. eg https://your_firebase.firebaseio.com/hubot


## (Optional) Firebase Authentication
Set the enviornment variable `FIREBASE_SECRET` generated here from Firebase (https://your_firebase.firebaseio.com/?page=Admin)

Create a security rule to allow read/write in the `hubot` scope. (https://your_firebase.firebaseio.com/?page=Security). Note that your `FIREBASE_URL` must scope to `hubot` as shown above for authentication to work.

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
