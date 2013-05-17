class QuestionSet
  constructor: (questions) ->
    @questions = {}

    for question in questions
      @questions[question.id] = question

  findById: (id, callback) ->
    if @questions[id]?
      callback(null, @questions[id])
    else
      callback("not found")

QuestionSetBuilder =
  buildQuestionSet: (json) ->
    questions = []

    for questionJson in json
      questions.push @buildQuestion(questionJson)

    new QuestionSet(questions)

  buildQuestion: (json) ->
    options = []

    for optionJson in json.options
      options.push @buildOption(optionJson)

    new Models.Question(json.id, json.text, options)

  buildOption: (json) ->
    new Models.QuestionOption(json.text, json.value)

qustionSetJson = """
[
  {
    "id": "1",
    "text": "Do you agree with it?",
    "options": [
      { "text": "Yes", "value": "Y" },
      { "text": "No", "value": "N" }
    ]
  },
  {
    "id": "2",
    "text": "Do you like with it?",
    "options": [
      { "text": "Yes", "value": "Y" },
      { "text": "No", "value": "N" }
    ]
  },
  {
    "id": "3",
    "text": "Will you buy it?",
    "options": [
      { "text": "Yes", "value": "Y" },
      { "text": "No", "value": "N" }
    ]
  }
]
"""

sample = QuestionSetBuilder.buildQuestionSet JSON.parse(qustionSetJson)
exports = module.exports = sample
