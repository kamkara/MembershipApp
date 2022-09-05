Rails.application.routes.draw do
  get "feed", to:'home#index'

  get "team-sign-up", to: 'membership#team'
  get "ambassadeur-sign-up" , to:'membership#ambassador'
  get "teacher-sign-up" , to:'membership#teacher'
  get "team_in" , to:'membership#teamIn'
  resources :posts
    #Membership 
  devise_scope :user do
    get '/student-sign-in', to: 'devise/sessions#new'
    get '/student-sign-up', to: 'devise/registrations#new', as: "new_user_registration"
    delete '/sign-out', to: 'devise/sessions#destroy'
  end

  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
   root "posts#index"
end
