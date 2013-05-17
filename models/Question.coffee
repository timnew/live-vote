class Question
  constructor: (@id, @text, @options) ->
    @answers = {}

    for option in options
      @answers[option.value] = []

  answer: (id, value) ->
    if @answers[value]?
      @answers[value].push(id)
      @refresh()

  refresh: ->
    status = {}
    for key, values of @answers
      status[key] = values.length

    console.log status
    Models.EventSource.tapIfExists this, @id, (eventSource) ->
      eventSource.publish status, 'update'

  buildInitialData: ->
    for option in @options
      {
        text: option.text
        value: option.value
        count: @answers[option.value].length
      }


exports = module.exports = Question
