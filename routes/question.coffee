exports.question = (req, res) ->
  Records.QuestionSet.findById req.params.questionId, (err, question) ->
    res.render 'vote/question',
      question: question
      eventStreamUrl: "/question/#{req.params.questionId}/status-stream"
      initialData: question.buildInitialData()

exports.answer = (req, res) ->
  console.log req.body
  Records.QuestionSet.findById req.params.questionId, (err, question) ->
    question.answer req.body.id, req.body.value
    res.send 200

exports.answer.view = (req, res) ->
  Records.QuestionSet.findById req.params.questionId, (err, question) ->
    res.render 'vote/answer',
      question: question

exports.statusStream = (req, res) ->
  eventSource = Models.EventSource.getOrCreate "Question", req.params.questionId
  eventSource.hookClient(req, res)
