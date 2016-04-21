{ Surveys, Answers } = require "/imports/api/surveys.coffee"

exports.removeSurvey = new ValidatedMethod
  name : "survey.removeSurvey"
  validate : new SimpleSchema
    id :
      type : String
  .validator()
  run : ({id}) ->
    unless Surveys.findOne(id).authorId is @userId
      throw new Meteor.Error "survey.removeSurvey unauthorized",
      "user is not author of survey"
    Surveys.remove id
    Answers.remove
      surveyId : id