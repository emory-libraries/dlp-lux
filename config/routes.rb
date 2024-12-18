# frozen_string_literal: true
Rails.application.routes.draw do
  namespace :admin do
    resources :content_blocks
    resources :explore_collections

    root to: "admin#index"
  end
  concern :range_searchable, BlacklightRangeLimit::Routes::RangeSearchable.new
  concern :iiif_search, BlacklightIiifSearch::Routes.new
  mount Blacklight::Engine => '/'
  mount BlacklightAdvancedSearch::Engine => '/'

  concern :marc_viewable, Blacklight::Marc::Routes::MarcViewable.new

  root to: "catalog#index"
  concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :searchable
    concerns :range_searchable
  end

  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }

  # Disable these routes if you are using Devise's
  # database_authenticatable in your development environment.
  unless AuthConfig.use_database_auth?
    devise_scope :user do
      get 'users/sign_in', to: 'omniauth#new', as: :new_user_session
      post 'users/sign_in', to: 'omniauth_callbacks#shibboleth', as: :new_session
      get 'users/sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
    end
  end

  concern :exportable, Blacklight::Routes::Exportable.new

  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns [:exportable, :marc_viewable]
    concerns :iiif_search
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end

  get "/uv/config/:id", to: "application#uv_config", as: "uv_config", defaults: { format: :json }
  get "/contact", to: "static#contact"
  get "/about", to: "static#about"

  # Redirect requests for PURLs to the same object in the catalog controller
  # Status 303 is 'Found'. We don't want to suggest the object has moved.
  get '/purl/:obj_id', to: redirect('/catalog/%{obj_id}', status: 303)

  match '/404', to: 'static#not_found', via: :all

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
