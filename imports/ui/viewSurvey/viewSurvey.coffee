require "/imports/ui/viewSurvey/viewSurvey.jade"
{ Surveys, Answers } = require "/imports/api/surveys.coffee"
{ Voted } = require "/imports/api/voted.coffee"
require "/node_modules/semantic-ui-css/semantic.min.js"

Template.selectSurveyView.viewmodel
  mayVote : ->
    unless Meteor.user()?
      false
    else
      voted = Voted.findOne
        userId : Meteor.userId()
        surveyId : FlowRouter.getParam "id"
      not voted?
  autorun : ->
    surveyId = FlowRouter.getParam "id"
    ti = @templateInstance
    console.log "subscribe Survey", surveyId
    ti.subscribe "Survey", surveyId
    ti.subscribe "Voted.onSurvey", Meteor.userId(), surveyId
    ti.subscribe "Answers.forSurvey", surveyId

Template.viewSurvey.viewmodel
  id : -> FlowRouter.getParam "id"
  survey : ->
    Surveys.findOne @id()
  answers : ->
    Answers.find
      surveyId : @id()
    ,
      sort :
        order : 1

Template.viewAnswer.viewmodel
  ordinal : -> @order() + 1

Template.voteSurvey.viewmodel
  id : -> FlowRouter.getParam "id"
  answerSelected : ""
  addedAnswer : ""
  survey : ->
    Surveys.findOne @id()
  answers : ->
    Answers.find
      surveyId : @id()
    ,
      sort :
        order : 1
  loggedIn : -> !!Meteor.user()
  voteButtonEnabled : ->
    @answerSelected() isnt "" and
    (@answerSelected() isnt "addedAnswer" or @addedAnswer() isnt "")
  vote : ->
    setVoted = =>
      Meteor.users.update Meteor.userId(),
        $addToSet :
          votedOn : @id()
    if @loggedIn()
      unless @answerSelected() is ""
        unless @answerSelected() is "addedAnswer"
          Answers.update @answerSelected(),
            $inc :
              amount : 1
          setVoted()
        else
          order = Answers.find({surveyId : @id()}).count()
          Answers.insert
            surveyId : @id()
            text : @addedAnswer()
            amount : 1
            order : order
          setVoted()

Template.voteAnswer.viewmodel
  selected : -> false
  ordinal : -> @order() + 1