Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'api/v1/auth'
  root 'welcome#index'
  resources :apidocs, only: [:index]
  get '/docs' => redirect('/swagger/dist/index.html?url=/apidocs')
  namespace :api do
  	namespace :v1 do
  		resources :sessions, only: :create
  		resources :registrations, only: :create
  		resources :cases
      resources :species
      resources :diseases
      resources :symptoms
      resources :farmers
      resources :users
      resources :regions, only: :index
      resources :campaigns
      resources :animal_tags, only: [:create, :update]
      resources :animal_tag_vaccinations, only: [:create]
      resources :subscriptions, only: :create
      resources :cards, only: :create
      resources :payments, only: :create
      resources :vaccination_schedules, only: [:create, :update, :destroy]
      resources :type_of_campaigns, only: :index
      resources :communities, only: [:create, :update, :destroy]
      resources :notifications
      post 'analytics/activations_search', to: 'analytics#activations_search'
      post 'analytics/user_activations_search', to: 'analytics#user_activations_search'
      post 'analytics/user_subscribers_search', to: 'analytics#user_subscribers_search'
      post 'analytics/user_revenue_search', to: 'analytics#user_revenue_search'
      post 'analytics/subscribers_search', to: 'analytics#subscribers_search'
      post 'analytics/revenue_search', to: 'analytics#revenue_search'
      post 'analytics/subscriptions_revenue_search', to: 'analytics#subscriptions_revenue_search'
      post 'analytics/vaccine_deliveries_revenue_search', to: 'analytics#vaccine_deliveries_revenue_search'
      post 'analytics/commission_on_vaccine_deliveries_revenue_search', to: 'analytics#commission_on_vaccine_deliveries_revenue_search'
      post 'my_cases', to: 'cases#my_cases'
      post 'my_farmers', to: 'farmers#my_farmers'
      get 'all_regions', to: 'regions#all_regions'
      get 'analytics/admin_dashboard_stats', to: 'analytics#admin_dashboard_stats'
      get 'analytics/manager_dashboard_stats', to: 'analytics#manager_dashboard_stats'
      get 'analytics/provider_dashboard_stats/:id', to: 'analytics#provider_dashboard_stats'
      get 'analytics/user_dashboard_stats/:id', to: 'analytics#user_dashboard_stats'
      get 'analytics/revenue', to: 'analytics#revenue'
      get 'filtered_cases/:filter', to: 'cases#filtered_cases'
      get 'campaigns/vaccination_schedules/:campaign_id', to: 'campaigns#vaccination_schedules'
      post 'campaigns/add_schedule_to_campaign', to: 'campaigns#add_schedule_to_campaign'
      post 'campaigns/add_provider_to_campaign', to: 'campaigns#add_provider_to_campaign'
      post 'campaigns_list', to: 'campaigns#campaigns_list'
      post 'zones/latest_zones', to: 'zones#latest_zones'
      get 'active_subscribers', to: 'farmers#active_subscribers'
      post 'subscribers/range_search', to: 'farmers#range_search'
      get 'expired_subscribers', to: 'farmers#expired_subscribers'
      get 'districts/districts_for_region/:id', to: 'districts#districts_for_region'
      get 'zones/zones_for_district/:id', to: 'zones#zones_for_district'
      post 'campaign_type_list', to: 'type_of_campaigns#campaign_type_list'
      post 'updated_subscriptions_list', to: 'subscriptions#updated_subscriptions_list'
      get 'my_commissions', to: 'commissions#my_commissions'
      get 'user', to: 'users#user';
      get 'agent_list', to: 'users#agent_list'
      get 'provider_list', to: 'users#provider_list'
      get 'partner_list', to: 'users#partner_list'
      get 'region_select_options', to: 'regions#region_select_options'
      get 'district_select_options', to: 'districts#district_select_options'
      get 'zone_select_options', to: 'zones#zone_select_options'
      get 'districts_for_region_select_options/:id', to: 'districts#districts_for_region_select_options'
      get 'zones_for_district_select_options/:id', to: 'zones#zones_for_district_select_options'
      get 'communites_for_zone_select_options/:id', to: 'communities#communites_for_zone_select_options'
      post 'my_latest_created_farmers', to: 'farmers#my_latest_created_farmers'
      post 'my_latest_updated_farmers', to: 'farmers#my_latest_updated_farmers'
      post 'new_farmers_list', to: 'farmers#new_farmers_list'
      post 'new_farmer_list', to: 'farmers#new_farmer_list'
      post 'updated_farmer_list', to: 'farmers#updated_farmer_list'
      post 'updated_farmers_list', to: 'farmers#updated_farmers_list'
      get 'uncompleted_schedules_select_options', to: 'vaccination_schedules#uncompleted_schedules_select_options'
      get 'provider_select_options', to: 'users#provider_select_options'
      get 'type_of_campaign_select_options', to: 'type_of_campaigns#type_of_campaign_select_options'
      get 'scheduled_campaigns', to: 'campaigns#scheduled_campaigns'
      get 'live_campaigns', to: 'campaigns#live_campaigns'
      get 'completed_campaigns', to: 'campaigns#completed_campaigns'
      get 'list_languages_from_aviato', to: 'campaigns#list_languages_from_aviato'
      get 'list_audio_files_from_aviato', to: 'campaigns#list_audio_files_from_aviato'
      post 'users/set_firebase_registration_token', to: 'users#set_firebase_registration_token'
      get 'users/provider/schedules', to: 'users#provider_schedules';
      post 'users/provider/updated_schedule_list', to: 'users#updated_provider_schedules'
      get 'payments/revenue_collections', to: 'payments#revenue_collections'
      get 'payments/total_collections', to: 'payments#total_collections'
      post 'users/account/new', to: 'users#new_user_account'
      get 'campaign_subscribers/:id/:zone', to: 'campaigns#campaign_subscribers'
      get 'wallet/get_famer/farmer/:phone_number', to: 'balances#farmer_account_balance'
      get 'wallet/get_agent_balance/:phone_number', to: 'balances#agent_account_balance'
      post 'campaigns/subscribe_to_campaign', to: 'campaignsubscriptions#subscribe_campaign'
      post 'campaigns/unsubscribe_from_campaign', to: 'campaignsubscriptions#unsubscribe_campaign'
    end
  end
end
