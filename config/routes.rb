Simpler.application.routes do
  get '/tests', 'tests#index'
  post '/tests', 'tests#create'
  get '/tests/:id', 'tests#show'
  # get '/tests/:test_id/questions/:id', 'questions#show'
end
