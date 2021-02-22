Rails.application.routes.draw do

  namespace :children_creation do
    resources :steps, only: %i[show update]
  end
  
  get "/pages/:page", to: "pages#show"

  get '/multi-step-form', to: "multi_step_form#new"
  post '/multi-step-form', to: "multi_step_form#create"

  get "/404", to: "errors#not_found", via: :all
  get "/422", to: "errors#unprocessable_entity", via: :all
  get "/500", to: "errors#internal_server_error", via: :all
end
