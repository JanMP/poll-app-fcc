require "/imports/ui/viewSurvey/viewSurvey.jade"
{ Surveys, Answers, Voted} = require "/imports/api/collections.coffee"
require "/node_modules/semantic-ui-css/semantic.min.js"
{ mayVote } = require "/imports/api/methods.coffee"

#Done:0 Only show Graph if there have been votes +cosmetic

ViewModel.share
  surveyData :
    surveyId : -> FlowRouter.getParam "id"
    survey : -> Surveys.findOne @surveyId
    answers : -> @survey().answers()
    voted : ->
      amountSum = (a,b) -> a + b.amount
      @answers().fetch().reduce(amountSum, 0) isnt 0
  clientAddress :
    clientAddress : ""
    onCreated : ->
      Meteor.call "getClientAddress", (err, result) =>
        if err then throw err
        @clientAddress result


Template.selectSurveyView.viewmodel
  share : ["surveyData", "clientAddress"]
  mayVote : ->
    if @survey()?.allowUnauthorized
      voted = Voted.findOne
        surveyId : @surveyId()
        userId : @clientAddress()
      not voted?
    else
      unless Meteor.userId()
        false
      else
        voted = Voted.findOne
          surveyId : @surveyId()
          userId : Meteor.userId()
        not voted?
  loading : -> not @templateInstance.subscriptionReady()
  autorun : ->
    @templateInstance.subscribe "Survey", @surveyId()

Template.viewSurvey.viewmodel
  share : "surveyData"

Template.viewAnswer.viewmodel
  ordinal : -> @order() + 1

Template.voteSurvey.viewmodel
  share : "surveyData"
  answerSelected : ""
  addedAnswer : ""
  loggedIn : -> !!Meteor.user()
  voteButtonEnabled : ->
    @answerSelected() isnt "" and
    (@answerSelected() isnt "addedAnswer" or @addedAnswer() isnt "")
  vote : ->
    unless @answerSelected() is "addedAnswer"
      Meteor.call "survey.vote",
        answerId : @answerSelected()
    else
      Meteor.call "survey.addAnswer",
        surveyId : @surveyId()
        text : @addedAnswer()
      #Done:10 use Method addAnswer

Template.voteAnswer.viewmodel
  selected : -> false
  ordinal : -> @order() + 1
