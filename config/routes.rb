Madbooker::Application.routes.draw do

  resources :hotels

  devise_for :users, :path_names => { :sign_in => 'login', :sign_out => 'logout' } #do
  
  root :to => 'home#index'
  
  get "/privacy", :to => "home#privacy"
  get "/terms", :to => "home#terms"
end
