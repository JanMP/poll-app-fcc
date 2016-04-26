{Mongo} = require "meteor/mongo"

Surveys = new Mongo.Collection "surveys"
Answers = new Mongo.Collection "answers"
Voted = new Mongo.Collection "voted"

Surveys.schema = new SimpleSchema
  title :
    type : String
  question :
    type : String
  authorName :
    type : String
  authorId :
    type : String
  allowAddAnswer :
    type : Boolean
    optional : true
  allowUnauthorized :
    type : Boolean
    optional : true

Surveys.schemaLight = new SimpleSchema
  title :
    type : String
  question :
    type : String
  allowAddAnswer :
    type : Boolean
    optional : true
  allowUnauthorized :
    type : Boolean
    optional : true

Surveys.freshSurvey = ->
  title : ""
  question : ""
  authorName : Meteor.user()?.emails[0]?.address
  authorId : Meteor.userId()
  allowAddAnswer : false

Surveys.attachSchema Surveys.schema

Surveys.helpers
  answers : ->
    Answers.find
      surveyId : @_id
    ,
      sort :
        order : 1

Answers.schema = new SimpleSchema
  surveyId :
    type : String
  text :
    type : String
  amount :
    type : Number
  order :
    type : Number
    decimal : true

Answers.schemaLight = new SimpleSchema
  _id :
    type : String
    optional : true
  surveyId :
    type : String
    optional : true
  text :
    type : String
  amount :
    type : Number
    optional : true
  order :
    type : Number
    decimal : true

Answers.freshAnswer = (surveyId = "", order = 0) ->
  surveyId : surveyId
  text : ""
  amount : 0
  order : order

Answers.attachSchema Answers.schema

Voted.attachSchema new SimpleSchema
  userId :
    type : String
  surveyId :
    type : String

exports.Voted = Voted

exports.Surveys = Surveys
exports.Answers = Answers
