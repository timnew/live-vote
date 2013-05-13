class Question
  constructor: (@text, options) ->
    @options = {}
    @answers = {}

    for option in options
      @options[option.value] = option
      @answers[option.value] = []

exports = module.exports = Question
