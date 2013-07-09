Madbooker::Application.routes.draw do

  resources :bookings, :only => [:show]

  resources :hotels do
    member do
      delete :delete_logo
    end
    resources :bookings do
      member do
        put :check_in
        put :check_out
        put :cancel
        put :open
        put :no_show
        put :pay
      end
      collection do
        get :search
        get :no_shows
      end
    end
    resources :packages
    resources :add_ons
    resources :check_ins
    resources :memberships
    resources :inventories do
      collection do
        get :form
        get ":year/:month", action: :index, as: "for_month"
        get ":year", action: :year, as: "for_year"
      end
    end
  end
  
  resource :book do
    post :select_dates
    post :select_room
    post :checkout
  end
  

  devise_for :users, :path_names => { :sign_in => 'login', :sign_out => 'logout' }
  
  root :to => 'home#index'
  
  get "/privacy", :to => "home#privacy"
  get "/terms", :to => "home#terms"
end
