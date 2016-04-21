{ Surveys, Answers } = require "/imports/api/surveys.coffee"
{ Voted } = require "/imports/api/voted.coffee"

Meteor.publish "Surveys.public", ->
  Surveys.find
    editing : false

Meteor.publish "Survey", (surveyId) ->
  Surveys.find surveyId

Meteor.publish "Answers.forSurvey", (surveyId) ->
  Answers.find
    surveyId : surveyId

Meteor.publish "Voted", (userId, surveyId) ->
  Voted.find
    userId : userId
    surveyId : surveyId