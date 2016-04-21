{Mongo} = require "meteor/mongo"

###
userProfileSchema = new SimpleSchema
  voted :
    type : [String]
    optional : true
###

Meteor.users.attachSchema = new SimpleSchema
  username :
    type : String
    optional : true
  emails :
    type : Array
    optional : true
  "emails.$" :
    type : Object
  "emails.$.address" :
    type : String
    regEx : SimpleSchema.RegEx.Email
  "emails.$.verified" :
    type : Boolean
  createdAt :
    type : Date
  profile :
    type : Object
    optional : true
  services :
    type : Object
    optional : true
    blackbox : true
  votedOn :
    type : [String]
    optional : true
  heartbeat :
    type : Date
    optional : true

