# Description:
#   A Hubot script to persist Hubot's brain using FireBase
#
# Configuration:
#   FIREBASE_URL - eg https://your_firebase.firebaseio.com/hubot
#   FIREBASE_SECRET - (optional) Authentication to FireBase
#
# Commands:
#   None

# Require Firebase dependencies
Firebase                = require 'firebase'
FirebaseTokenGenerator  = require 'firebase-token-generator'

# Main export
module.exports = (robot) ->
  
  # Do not load unless configured
  return robot.logger.warning "firebase-brain: FIREBASE_URL not set. Not attempting to load FireBase brain." unless process.env.FIREBASE_URL?

  robot.logger.info "firebase-brain: Connecting to FireBase brain at #{process.env.FIREBASE_URL} "

  # Turn off autosave until Firebase connected successfully
  robot.brain.setAutoSave false

  # expose this reference to the Robot
  robot.firebaseBrain = new Firebase process.env.FIREBASE_URL
    
  # Log authentication
  onAuthCallback = (authData) ->
    if authData
      robot.logger.info 'firebase-brain: Authenticated successfully'
    else
      robot.logger.info 'firebase-brain: Client unauthenticated.'

  # Do authentication
  authenticate = (authData) =>
    robot.logger.info "firebase-brain: Attempting to authenticate using FIREBASE_SECRET"

    tokenGenerator = new FirebaseTokenGenerator process.env.FIREBASE_SECRET
    token = tokenGenerator.createToken({ "uid": "custom:hubot", "hubot": true });
    
    robot.firebaseBrain.authWithCustomToken token, (error, authData) ->
      if error
        robot.logger.warning 'firebase-brain: Login Failed!', error
  
  if process.env.FIREBASE_SECRET?
    do authenticate
    robot.firebaseBrain.offAuth authenticate
    robot.firebaseBrain.offAuth onAuthCallback
    robot.firebaseBrain.onAuth  onAuthCallback
    
  # Load the initial persistant brain
  robot.firebaseBrain.once 'value', (data) ->
    robot.logger.info "firebase-brain: Successfully connected to FireBase"
    robot.brain.mergeData data.val()
    robot.brain.setAutoSave true
    
  # As values change in Firebase load them into the local brain
  robot.firebaseBrain.on "value", (data)->
   robot.logger.debug "firebase-brain: Updating brain from FireBase"
   robot.brain.data = data.val()
   robot.brain.save()

  # Flush brain to firebase on the 'save' event
  robot.brain.on 'save', (data = {}) ->
    robot.logger.debug "firebase-brain: Saving brain to FireBase"
    sanatized_data = JSON.parse JSON.stringify(data)
    robot.firebaseBrain.set sanatized_data

  # Shutdown the brain
  robot.brain.on 'close', ->
    robot.firebaseBrain.goOffline()

