exports = module.exports = (app) ->
  app.get '/', Routes.home.index

  app.get '/vote/:id', Routes.vote.summary
  app.get '/vote/:id/form', Routes.vote.form

  app.post '/api/:id/', Routes.api.vote
  app.get '/api/:id/', Routes.api.stream




  
