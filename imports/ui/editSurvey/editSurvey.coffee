require "/imports/ui/editSurvey/editSurvey.jade"
{ Surveys, Answers } = require "/imports/api/surveys.coffee"
require "/node_modules/semantic-ui-css/semantic.min.js"
require "/imports/sortable/sortable-meteor.coffee"

Template.editSurvey.viewmodel
  id : -> FlowRouter.getParam "id"
  survey : ->
    Surveys.findOne @id()
  answers : ->
    Answers.find
      surveyId : @id()
    ,
      sort :
        order : 1
  autorun : ->
    if @id() is "new"
      editSurvey = Surveys.findOne
        authorId : Meteor.userId()
        editing : true
      if editSurvey?
        FlowRouter.go "/edit-survey/#{editSurvey._id}"
      else
        Surveys.insert Surveys.freshSurvey(), (err, id) ->
          unless err?
            FlowRouter.go "/edit-survey/#{id}"
          else
            console.log err
  loggedIn : -> !!Meteor.user()
  
  addQuestion : (event) ->
    event.preventDefault()
    order = @answers().count()
    Answers.insert Answers.freshAnswer(@id(), order)
    
  publish : (event) ->
    event.preventDefault()
    console.log @survey()
    Surveys.update @id(),
      $set:
        editing : false
    FlowRouter.go "/"

  sortableOptions : ->
    sort : true
    sortField : "order"
    draggable : ".draggable"
    handle : ".handle"

Template.editSurveyForm.viewmodel
  onRendered : -> @checkbox.checkbox()

  update : ->
    Surveys.update @_id(),
      $set :
        title : @title()
        question : @question()
        allowAddAnswer: @allowAddAnswer()

Template.answerEdit.viewmodel
  update : ->
    console.log "update answer", @_id()
    Answers.update @_id(),
      $set :
        text : @text()

  remove : ->
    console.log "remove answer", @_id()
    Answers.remove @_id()
