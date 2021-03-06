Rails.application.routes.draw do

  require 'sidekiq/web'
  require 'sidekiq/cron/web'

  def api_version(version, default = false, &routes)
    api_constraint = ApiConstraints.new(version: version, default: default)
    scope(module: "v#{version}", path: "v#{version}", constraints: api_constraint, &routes)
  end

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_USERNAME"])) &
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_PASSWORD"]))
  end
  mount Sidekiq::Web, at: "/sidekiq"

  get '/health', to: proc { [200, {}, ['']] }

  namespace :api, defaults: {format: :json} do
    api_version(1, true) do
      resource :users do
        member do
          put 'likes' => 'users#like_candidate'
          get 'likes' => 'users#liked_candidates'
        end

        # # # resource :comments
        # member do
        #   resource :comments, only: [:create, :show], module: :candidates do
        #     member do
        #       delete ':id' => 'comments#destroy'
        #     end
        #   end
        # end
      end

      get 'sessions' => 'users#check_session' # my comments

      # resource :comments, only: [:destroy, :show]
      delete 'comments/:id' => 'comments#destroy'
      get 'comments/:id' => 'comments#show'
      put 'comments/:id' => 'comments#update'
      get 'comments' => 'comments#index' # my comments

      resource :candidates do
        get '/' => 'candidates#index'
        get ':id' => 'candidates#show'
        get ':id/comments' => 'candidates#show_comments'
        post ':id/comments' => 'candidates#create_comments'

        # member do
        #   put 'likes' => 'candidates#like_candidate'
        #   get 'likes' => 'candidates#liked_candidates'
        # end
      end

      get 'cities' => 'v2020s#cities'
      get 'voting_districts' => 'v2020s#voting_districts'
      get 'voting_districts/:id' => 'v2020s#show'
      get 'district_by_location' => 'v2020s#district_by_location'

      # resource :boards, only: [:index, :create, :destroy]
      get 'boards' => 'boards#index'
      get 'heads' => 'boards#heads'
      post 'boards' => 'boards#create'
      delete 'boards' => 'boards#destroy'

    end
  end
end
