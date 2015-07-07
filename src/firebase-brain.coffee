# Description:
#   A hubot script to persist hubot's brain using firebase - because, why not?
#
# Configuration:
#   FIREBASE_URL - eg https://your_firebase.firebaseio.com/hubot
#   FIREBASE_SECRET - (optional) Custom authentication to firebase
#
# Commands:
#   None

Firebase = require 'firebase'
FirebaseTokenGenerator = require 'firebase-token-generator'
module.exports = (robot) ->

  if process.env.FIREBASE_URL?

    robot.logger.info "firebase-brain: Connecting to Firebase brain at #{process.env.FIREBASE_URL} "

    robot.brain.setAutoSave false

    firebaseBrain = new Firebase(process.env.FIREBASE_URL)

    if process.env.FIREBASE_SECRET?
      robot.logger.info "firebase-brain: Attempting to authenticate using FIREBASE_SECRET"

      tokenGenerator = new FirebaseTokenGenerator process.env.FIREBASE_SECRET
      token = tokenGenerator.createToken({ "uid": "custom:hubot", "hubot": true });
      firebaseBrain.authWithCustomToken token, (error, authData) ->
        if error
          robot.logger.warning 'firebase-brain: Login Failed!', error
        else
          robot.logger.info 'firebase-brain: Authenticated successfully'


    firebaseBrain.once 'value', (data) ->
      robot.logger.info "hubot-firebase-brain: Successfully connected to Firebase"
      robot.brain.mergeData data.val()
      robot.brain.setAutoSave true

    firebaseBrain.on "value", (data)->
      robot.logger.debug "Updating brain from firebase"
      robot.brain.mergeData data.val()

    robot.brain.on 'save', (data = {}) ->
      robot.logger.debug 'Saving brain to firebase'
      sanatized_data = JSON.parse JSON.stringify(data)
      firebaseBrain.set sanatized_data

    robot.brain.on 'close', ->
      firebaseBrain.goOffline()

  else
    robot.logger.warning "firebase-brain: FIREBASE_URL not set. Not attempting to load Firebase brain."
