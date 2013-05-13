QuestionSetBuilder =
  buildQuestionSet: (json) ->
    questions = []

    for questionJson in json
      questions.push @buildQuestion(questionJson)

    new Models.QuestionSet(questions)

  buildQuestion: (json) ->
    options = []

    for optionJson in json.options
      options.push @buildOption(optionJson)

    new Models.Question(json.text, options)

  buildOption: (json) ->
    new Models.QuestionOption(json.text, json.value)

sample = QuestionSetBUilder.buildQuestionSet [
{
  text: 'Do you agree with it?'
  options: [
  { text: 'Yes', value: true },
  { text: 'No', value: false }
  ]
},
{
  text: 'Do you like with it?'
  options: [
  { text: 'Yes', value: true },
  { text: 'No', value: false }
  ]
},
{
  text: 'Will you buy it?'
  options: [
  { text: 'Yes', value: true },
  { text: 'No', value: false }
  ]
},
]

exports = module.exports = sample
