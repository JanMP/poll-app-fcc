require "/imports/ui/editSurvey/editSurvey.jade"
{ Surveys, Answers } = require "/imports/api/collections.coffee"
require "/node_modules/semantic-ui-css/semantic.min.js"
require "/imports/sortable/sortable-meteor.coffee"

{ Mongo } = require "meteor/mongo"

AnswersLocal = new Mongo.Collection null

Template.editSurvey.viewmodel

  #input fields:
  title : ""
  question : ""
  allowAddAnswer : false
  allowUnauthorized : false
  answers : ->
    AnswersLocal.find {},
      sort :
        order : 1

  #buttons:
  addQuestion : (event) ->
    event.preventDefault()
    order = @answers().count()
    AnswersLocal.insert Answers.freshAnswer("", order)

  publish : (event) ->
    event.preventDefault
    Meteor.call "survey.insertSurvey",
      survey :
        title : @title()
        question : @question()
        allowAddAnswer : @allowAddAnswer()
        allowUnauthorized : @allowUnauthorized()
      answers : AnswersLocal.find({}).fetch()
    ,
      (err, res) ->
        if err then throw err
        AnswersLocal.remove {}
        FlowRouter.go "/"

  #misc helpers
  loggedIn : -> !!Meteor.user()

  sortableOptions : ->
    sort : true
    sortField : "order"
    draggable : ".draggable"
    handle : ".handle"

  #onRendered : -> @checkbox.checkbox()

Template.answerEdit.viewmodel
  text : ""
  update : ->
    AnswersLocal.update @_id(),
      $set :
        text : @text()

  remove : ->
    AnswersLocal.remove @_id()
