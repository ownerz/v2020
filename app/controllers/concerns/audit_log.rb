# frozen_string_literal: true

module AuditLog
  extend ActiveSupport::Concern

  included do
    # before_action :audit_log
    after_action :audit_log
  end

  def audit_log
    begin
      ret = UserAudit.create!( device_id: request.headers[:HTTP_DEVICE_ID],
                        request_url: request.url,
                        geo_info: geoip,
                        remote_ip: request.remote_ip)
    rescue => e
      Rails.logger.error(":::: UserAudit.create error: #{e} ::::")
    end
  end

  private

  def geoip
    Geocoder.search(request.remote_ip).to_json
  end

  def filtered_params
    params.except(:controller, :action, :utf8, :authenticity_token, :commit)
  end
end
