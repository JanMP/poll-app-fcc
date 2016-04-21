require "/imports/ui/chart/chart.jade"
Chartist = require "/node_modules/chartist/dist/chartist.js"
{ Surveys, Answers } = require "/imports/api/surveys.coffee"

options =
  labelInterpolationFnc : (value) -> value[0]

responsiveOptions = [
  [
    "screen and (min-width: 640px)",
    chartPadding : 30
    labelOffset : 100
    labelDirection : "explode"
    labelInterpolationFnc : (value) -> value
  ]
  [
    "screen and (min-width: 1024px",
    labelOffset : 80
    chartPadding : 20
  ]
]

Template.chart.viewmodel
  chartData : ->
    answers = Answers.find
      surveyId : @_id()
    ,
      sort :
        order : 1
    .fetch()
    #return
    labels : answers.map (d) ->
      if d.text.length < 20
        "#{d.order + 1}: #{d.text}"
      else
        "#{d.order}"
    series : answers.map (d) -> d.amount
  autorun : ->
    new Chartist.Pie ".ct-chart", @chartData(), options, responsiveOptions