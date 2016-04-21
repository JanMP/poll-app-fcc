{Mongo} = require "meteor/mongo"

Voted = new Mongo.Collection "voted"

Voted.attachSchema new SimpleSchema
  userId :
    type : String
  surveyId :
    type : String

exports.Voted = Voted