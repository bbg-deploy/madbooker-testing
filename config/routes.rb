Madbooker::Application.routes.draw do
  
  resources :projects do
    resources :project_memberships
    member do
      post :set_project_name
    end
  end
  resources :people

  match '/users/auth/:provider/callback' => 'authentications#create'
  devise_for :users, :controllers => {:registrations => 'registrations'}, :path_names => { :sign_in => 'login', :sign_out => 'logout' } do
    get 'login' => 'devise/sessions#new', :as => :new_user_session
    post 'login' => 'devise/sessions#create', :as => :user_session
    get 'signup'  => 'registrations#new', :as => :new_user_registration
    get 'signout' => 'devise/sessions#destroy', :as => :destroy_user_session
  end
  resources :users
  match "/login", :to => "devise/sessions#new"
  match "/signup", :to => "registrations#new"
  match "/signout", :to => "devise/sessions#destroy"
  
  root :to => 'home#index'
  
  
  
  match "/privacy", :to => "home#privacy"
  match "/terms", :to => "home#terms"

end
