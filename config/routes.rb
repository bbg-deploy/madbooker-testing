Madbooker::Application.routes.draw do


  resources :bookings, :only => [:show]
  match "/stripe" => "stripes#event", via: [:get, :post]
  
  resources :hotels do
    member do
      delete :delete_logo
    end
    collection do
      get 'setup_instructions'
      get :ga_instructions
      get :ga_code
    end
    resources :packages
    resources :add_ons
    resources :memberships
    resources :sales_taxes
    resources :room_types do
      member do
        delete :delete_image
      end
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
    resource :reports do
      collection do
        get :searches
        get :revenue
        get :revenue_by_room_type
        get :daily
        get :funnel
        get :ga
        get :visits
        get :cities
        get :sources
        get :google_auth
        get :denials
        delete :remove_google_auth
      end
    end
    resources :inventories do
      collection do
        get :form
      end
    end
  end
  
  get "/hotels/:hotel_id/inventories/month/:year/:month", to: "inventories#month", as: :month_hotel_inventories
  get "/oauth2callback", to: "reports#oauth2callback", as: :oauth2callback
  
  resource :book do
    post :select_dates
    post :select_room
    post :checkout
  end
  
  resources :inviteds
  get "/invited/:guid", to: "inviteds#show", as: :guid_invited
  

  devise_for :users, :path_names => { :sign_in => 'login', :sign_out => 'logout' } do
    get "logout" => "devise/sessions#logout"
  end
  
  root :to => 'home#index'

  get "/setup", :to => "home#setup"
  get "/features", :to => "home#features"
  get "/privacy", :to => "home#privacy"
  get "/terms", :to => "home#terms"
  get "/not_authorized", :to => "home#not_authorized", as: :not_authorized
  
end
