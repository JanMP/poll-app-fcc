require "/imports/ui/chart/chart.jade"
Chartist = require "/node_modules/chartist/dist/chartist.js"
{ Surveys, Answers } = require "/imports/api/collections.coffee"
_ = require "/node_modules/lodash"
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
    sum = _(answers).sumBy "amount"
    #return
    labels : answers.map (d) ->
      percentage = Math.round(d.amount / sum * 100)
      if d.amount is 0
        " " #with an empty the series value would be used
      else
        if d.text.length < 20
         "#{d.order + 1}: #{d.text} #{percentage}%"
        else
          "#{d.order} #{percentage}%"
    series : answers.map (d) -> d.amount
  autorun : ->
    new Chartist.Pie ".ct-chart", @chartData(), options, responsiveOptions
