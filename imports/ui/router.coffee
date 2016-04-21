FlowRouter.route "/",
  name : "home"
  action : ->
    BlazeLayout.render "layout",
      main : "listSurveys"

FlowRouter.route "/edit-survey/:id",
  name : "editSurvey"
  action : ->
    BlazeLayout.render "layout",
      main : "editSurvey"

FlowRouter.route "/vote-survey/:id",
  name : "voteSurvey"
  action : ->
    BlazeLayout.render "layout",
      main : "selectSurveyView"

FlowRouter.route "/info",
  name : "info"
  action : ->
    BlazeLayout.render "layout",
      main : "info"

FlowRouter.route "/settings",
  name : "settings"
  action : ->
    BlazeLayout.render "layout",
      main : "settings"

FlowRouter.route "/help",
  name : "help"
  action : ->
    BlazeLayout.render "layout",
      main : "help"