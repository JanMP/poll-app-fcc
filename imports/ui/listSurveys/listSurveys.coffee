require "/imports/ui/listSurveys/listSurveys.jade"
{ Surveys, Answers } = require "/imports/api/collections.coffee"

Template.listSurveys.viewmodel
  surveys : ->
    Surveys.find {}
  mayCreate : -> Meteor.user()?
  onCreated : ->
    @templateInstance.subscribe "Surveys.public"

Template.survey.viewmodel
  mayEdit : -> Meteor.user()? and Meteor.userId() is @authorId()
  vote : ->
    FlowRouter.go "/vote-survey/#{@_id()}"
  delete : ->
    Meteor.call "survey.removeSurvey",
      id : @_id()
    , (err, res) ->
      if err? then alert err