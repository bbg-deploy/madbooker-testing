Madbooker::Application.routes.draw do

  devise_for :users
  root :to => 'home#index'
  
  
  
  get "/privacy", :to => "home#privacy"
  get "/terms", :to => "home#terms"
end
# Madbooker::Application.routes.draw do
#   
#   resources :projects do
#     resources :project_memberships
#     member do
#       post :set_project_name
#     end
#   end
#   resources :people
# 
#   #get '/users/auth/:provider/callback' => 'authentications#create'
#   devise_for :users, :controllers => {:registrations => 'registrations'}, :path_names => { :sign_in => 'login', :sign_out => 'logout' } do
#   #   get 'login' => 'devise/sessions#new', :as => :new_user_session
#   #   post 'login' => 'devise/sessions#create', :as => :user_session
#   #   get 'signup'  => 'registrations#new', :as => :new_user_registration
#   #   get 'signout' => 'devise/sessions#destroy', :as => :destroy_user_session
#   end
#   resources :users
#   get "/login", :to => "devise/sessions#new"
#   get "/signup", :to => "registrations#new"
#   get "/signout", :to => "devise/sessions#destroy"
#   
#   root :to => 'home#index'
#   
#   
#   
#   get "/privacy", :to => "home#privacy"
#   get "/terms", :to => "home#terms"
# 
# end
