Madbooker::Application.routes.draw do

  resources :bookings, :only => [:show]
  match "/stripe" => "stripes#event", via: [:get, :post]
  
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
        get :check_ins
      end
    end
    resources :packages
    resources :add_ons
    resources :memberships
    resource :reports do
      collection do
        get :searches
        get :revenue
        get :revenue_by_room_type
        get :daily
        get :funnel
      end
    end
    resources :inventories do
      collection do
        get :form
      end
    end
  end
  
  resource :book do
    post :select_dates
    post :select_room
    post :checkout
  end
  

  devise_for :users, :path_names => { :sign_in => 'login', :sign_out => 'logout' } do
    get "logout" => "devise/sessions#logout"
  end
  
  root :to => 'home#index'
  
  get "/features", :to => "home#features"
  get "/privacy", :to => "home#privacy"
  get "/terms", :to => "home#terms"
  get "/not_authorized", :to => "home#not_authorized", as: :not_authorized
  
end
