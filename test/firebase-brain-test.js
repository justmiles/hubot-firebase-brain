require('coffee-script/register');

process.env.FIREBASE_URL = 'https://example.firebase.com/hubot';

var brain = require('../src/firebase-brain');

exports['brain instantiated'] = function(beforeExit, assert) {
    assert.isNotNull(brain);
};

exports['brain instantiated'] = function(beforeExit, assert) {
    assert.isNotNull(brain);
};

