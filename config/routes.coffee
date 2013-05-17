exports = module.exports = (app) ->
  app.get '/', Routes.home.index

  app.get '/question/:questionId', Routes.question.question
  app.get '/question/:questionId/answer', Routes.question.answer.view

  app.post '/question/:questionId/answer', Routes.question.answer
  app.get '/question/:questionId/status-stream', Routes.question.statusStream




  
