# frozen_string_literal: true

include ApplicationHelper

redis_url = Rails.application.credentials.dig(Rails.env.to_sym, :redis, :redis_url)
name_space = Rails.application.credentials.dig(Rails.env.to_sym, :redis, :redis_namespace)

redis_connection = Redis.new(
  url: redis_url,
  driver: :hiredis
)

if name_space
  Redis.current = Redis::Namespace.new(name_space, redis: redis_connection)
else
  Redis.current = redis_connection
end
