class CrawleringJob < ApplicationJob
  include ActiveJobRetryControlable
  queue_as :v2020
  retry_limit 1

  rescue_from(StandardError) do |exception|
    Rails.logger.error exception.message
    raise exception if retry_limit_exceeded?
    retry_job(wait: attempt_number**2)
  end

  def perform(*args)
    Sidekiq::Logging.logger.info("cralering job started")
    crawl_id = CrawleringService.new.crawlering
    Sidekiq::Logging.logger.info("cralering job finised. crawl_id = #{crawl_id}")
  end

end
