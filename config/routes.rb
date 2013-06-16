Madbooker::Application.routes.draw do


  resources :hotels do
    member do
      delete :delete_logo
    end
    resources :inventories do
      collection do
        get ":year/:month", action: :index, as: "for_date"
        get :form
      end
    end
  end

  devise_for :users, :path_names => { :sign_in => 'login', :sign_out => 'logout' } #do
  
  root :to => 'home#index'
  
  get "/privacy", :to => "home#privacy"
  get "/terms", :to => "home#terms"
end
