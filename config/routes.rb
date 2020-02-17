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
      resource :v2020, only: [:index, :show] do 
        get '/' => 'v2020s#index'
      end

    end
  end
end
