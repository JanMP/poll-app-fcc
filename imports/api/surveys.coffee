{Mongo} = require "meteor/mongo"

Surveys = new Mongo.Collection "surveys"
Answers = new Mongo.Collection "answers"

Surveys.schema = new SimpleSchema
  title :
    type : String
    optional : true
  question :
    type : String
    optional : true
  authorName :
    type : String
    optional : true
  authorId :
    type : String
    optional : true
  allowAddAnswer :
    type : Boolean
    optional : true
  editing :
    type : Boolean
    optional : true

Surveys.freshSurvey = ->
  title : ""
  question : ""
  authorName : Meteor.user()?.emails[0]?.address
  authorId : Meteor.userId()
  allowAddAnswer : false
  editing : true

Surveys.attachSchema Surveys.schema

Surveys.helpers
  answers : ->
    Answers.find
      surveyId : @_id

Answers.schema = new SimpleSchema
  surveyId :
    type : String
    optional : true
  text :
    type : String
    optional : true
  amount :
    type : Number
    optional : true
  order :
    type : Number
    decimal : true
    optional : true

Answers.freshAnswer = (surveyId = "", order = 0) ->
  surveyId : surveyId
  text : ""
  amount : 0
  order : order

Answers.attachSchema Answers.schema

exports.Surveys = Surveys
exports.Answers = Answers