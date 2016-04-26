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
      "user must be logged in to publish a survey"
    survey.authorName = Meteor.user()?.profile?.name
    survey.authorId = Meteor.userId()
    Surveys.insert survey, (err, surveyId) ->
      if err then throw err
      for answer in answers
        delete answer._id
        answer.surveyId = surveyId
        answer.amount = 0
        Answers.insert answer, (err, result) ->
          if err then throw err

exports.addAnswer = new ValidatedMethod
  name : "survey.addAnswer"
  validate : new SimpleSchema
    surveyId :
      type : String
    text :
      type : String
  .validator()
  run : ({surveyId, text}) ->
    #Done:20 implement Method addAnswer
    unless @userId?
      throw new Meteor.Error "survey.addAnswer unauthorized",
      "user must be logged in to add answers to survey"
    survey = Surveys.findOne surveyId
    answersCount = Answers.find(surveyId : surveyId).count()
    Answers.insert
      surveyId : surveyId
      text : text
      amount : 0
      order : answersCount
    ,
    (err, newAnswerId) ->
      if err
        throw err
      else
        Meteor.call "survey.vote",
          answerId : newAnswerId

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
    answer = Answers.findOne answerId
    surveyId = answer.surveyId
    survey = Surveys.findOne surveyId

    mayVote = =>
      if survey?.allowUnauthorized
        voted = Voted.findOne
          surveyId : surveyId
          userId : @connection?.clientAddress
        not voted?
      else
        unless @userId
          false
        else
          voted = Voted.findOne
            surveyId : surveyId
            userId : @userId
          not voted?

    unless mayVote()
      throw new Meteor.Error "survey.vote unauthorized",
      "may not vote on this survey"
    else
      Answers.update answerId,
        $inc :
          amount : 1
      Voted.insert
        surveyId : surveyId
        userId : if survey.allowUnauthorized
          @connection?.clientAddress or "theServerKnows"
        else
          @userId

Meteor.methods
  getClientAddress : -> @connection?.clientAddress
