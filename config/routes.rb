# frozen_string_literal: true
Rails.application.routes.draw do
  concern :range_searchable, BlacklightRangeLimit::Routes::RangeSearchable.new
  mount Blacklight::Engine => '/'

  get '/catalog/:id/citation' => 'blacklight/citeproc/citation#print_single'
  get '/bookmarks/citation' => 'blacklight/citeproc/citation#print_bookmarks'

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
  get "/copyright-reuse", to: "static#copyright_reuse"

  match '/404', to: 'static#not_found', via: :all

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
