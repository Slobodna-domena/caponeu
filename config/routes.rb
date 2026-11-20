Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  %w(404 422 500).each do |code|
    get code, controller: :homepage, action: :error, code: code
  end

  match "cdp/map", to: "map#index", via: [:get, :post], as: :map
  get "cdp/map/:type/:slug", to: "map#explore", as: :explore

  get "cdp_how", to: "homepage#cdp_how", as: :cdp_how
  get "terms", to: "homepage#terms", as: :terms
  get "privacy", to: "homepage#privacy", as: :privacy
  get "about", to: "homepage#about", as: :about
  get "about/events", to: "homepage#events", as: :about_events
  get "about/team", to: "homepage#team", as: :about_team
  get "cdp", to: "platform#index", as: :cdp_home
  get "page_404", to: "homepage#page_404", as: :page_404
  get "page_500", to: "homepage#page_500", as: :page_500

  get "cdp/timeline", to: "timeline#index", as: :cdp_timeline
  match "cdp/global_search", to: "search#global_search", via: [:get, :post], as: :cdp_global_search

  get "cdp/novels/:id", to: "novel#show", as: :cdp_show_novel
  match "cdp/novels", to: "novel#index", via: [:get, :post], as: :cdp_novels
  match "cdp/authors-index", to: "novel#authors_index", via: [:get, :post], as: :cdp_novels_authors_index
  get "cdp/authors-index/:id", to: "novel#authors_index_letter", as: :cdp_novels_authors_index_letter

  get "cdp/events/:id", to: "event#show", as: :cdp_show_event
  match "cdp/events", to: "event#index", via: [:get, :post], as: :cdp_event

  get "cdp/collections", to: "collections#index", as: :cdp_collections
  get "cdp/collections/:id", to: "collections#show", as: :cdp_show_collection

  get "cdp/search/novels", to: "novel#search", as: :cdp_search_novels
  get "cdp/search/materials", to: "material#search"
  get "cdp/search/people", to: "person#search", as: :cdp_search_people

  post "cdp/search/novels", to: "novel#search"
  post "cdp/search/people", to: "person#search"
  post "cdp/search/materials", to: "material#search", as: :cdp_material_search

  match "cdp/topics", to: "topic#index", via: [:get, :post], as: :cdp_topics
  get "cdp/topics/:id", to: "topic#show", as: :cdp_show_topic

  match "cdp/people", to: "person#index", via: [:get, :post], as: :cdp_people
  post "cdp/people", to: "person#index", as: :cdp_people_search
  get "cdp/people/:id", to: "person#show", as: :cdp_show_person

  #get "cdp/categories", to: "category#index", as: :cdp_categories
  get "cdp/categories/:id", to: "category#show", as: :cdp_show_category

  get "cdp/languages", to: "language#index", as: :cdp_languages
  get "cdp/languages/:id", to: "language#show", as: :cdp_show_language

  match "cdp/organizations", to: "organization#index", via: [:get, :post], as: :cdp_organizations
  get "cdp/organizations/:id", to: "organization#show", as: :cdp_show_organization

  match "cdp/materials", to: "material#index", via: [:get, :post], as: :cdp_materials
  get "cdp/materials/:id", to: "material#show", as: :cdp_show_material

  get "/news/", to: "news#index", as: :news
  get "/news/:id", to: "news#show", as: :news_single

  get "cdp/editions/:id", to: "edition#show", as: :cdp_show_edition

  get "login", to: "homepage#login", as: :login

  get "api/openlibrary", to: "homepage#openlibrary"

  post "/", to: "homepage#index"

  root "homepage#index"
end
