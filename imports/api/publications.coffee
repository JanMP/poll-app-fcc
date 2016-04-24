{ Surveys, Answers, Voted } = require "/imports/api/collections.coffee"

Meteor.publish "Surveys.public", ->
  Surveys.find {}

Meteor.publish "Survey", (surveyId) ->[
  Surveys.find surveyId
  Answers.find
    surveyId : surveyId
  Voted.find
    userId : @userId
    surveyId : surveyId
  ]