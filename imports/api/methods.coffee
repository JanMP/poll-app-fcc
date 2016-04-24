{ Surveys, Answers, Voted } = require "/imports/api/collections.coffee"

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

exports.insertSurvey = new ValidatedMethod
  name : "survey.insertSurvey"
  validate : new SimpleSchema
    survey :
      type : Surveys.schemaLight
    answers :
      type : [Answers.schemaLight]
  .validator()
  run : ({survey, answers}) ->
    unless @userId?
      throw new Meteor.Error "survey.insertSurvey unauthorized",
      "user must be logged in"
    survey.authorName = Meteor.user()?.emails[0]?.address
    survey.authorId = Meteor.userId()
    Surveys.insert survey, (err, surveyId) ->
      if err then throw err
      for answer in answers
        delete answer._id
        answer.surveyId = surveyId
        answer.amount = 0
        Answers.insert answer, (err, result) ->
          if err then throw err

exports.vote = new ValidatedMethod
  name : "survey.vote"
  validate : new SimpleSchema
    answerId :
      type : String
  .validator()
  run : ({answerId}) ->
    if answerId is ""
      throw new Meteor.Error "survey.vote missing answerId",
      "user must select an answer to vote"
    unless @userId?
      throw new Meteor.Error "survey.vote unauthorized",
      "user must be logged in to vote"
    answer = Answers.findOne answerId
    surveyId = answer.surveyId
    survey = Surveys.findOne surveyId
    votedObj =
      userId : @userId
      surveyId : answer.surveyId
    voted = Voted.findOne votedObj
    if voted?
      throw new Meteor.Error "survey.vote already voted",
      "user may only vote once on each survey"
    Answers.update answerId,
      $inc :
        amount : 1
    Voted.insert votedObj
