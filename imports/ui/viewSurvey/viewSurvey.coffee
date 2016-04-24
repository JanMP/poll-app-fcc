require "/imports/ui/viewSurvey/viewSurvey.jade"
{ Surveys, Answers, Voted} = require "/imports/api/collections.coffee"
require "/node_modules/semantic-ui-css/semantic.min.js"

#TODO: Only show Graph if there have been votes +cosmetic

ViewModel.share
  surveyData :
    surveyId : -> FlowRouter.getParam "id"
    survey : -> Surveys.findOne @surveyId
    answers : -> @survey().answers()

Template.selectSurveyView.viewmodel
  share : "surveyData"
  mayVote : ->
    unless Meteor.user()?
      false
    else
      voted = Voted.findOne
        userId : Meteor.userId()
        surveyId : @surveyId()
      not voted?
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
      order = @answers().count()
      newAnswerId = Answers.insert
        surveyId : @surveyId()
        text : @addedAnswer()
        amount : 0
        order : @answers().count()
      Meteor.call "survey.vote",
        answerId : newAnswerId


Template.voteAnswer.viewmodel
  selected : -> false
  ordinal : -> @order() + 1
