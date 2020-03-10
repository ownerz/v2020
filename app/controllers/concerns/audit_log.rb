# frozen_string_literal: true

module AuditLog
  extend ActiveSupport::Concern

  included do
    # before_action :audit_log
    after_action :audit_log
  end

  def audit_log
    begin
      geoinfo = get_geoinfo
      ret = UserAudit.create!( device_id: request.headers[:HTTP_DEVICE_ID],
                        request_url: request.url,
                        country: geoinfo[:country],
                        region: geoinfo[:region],
                        loc: geoinfo[:city],
                        postal: geoinfo[:postal],
                        city: geoinfo[:city],
                        remote_ip: request.remote_ip)
    rescue => e
      Rails.logger.error(":::: UserAudit.create error: #{e} ::::")
    end
  end

  private

  def get_geoinfo
    Geocoder.search(request.remote_ip).to_json
    # geoinfo = Geocoder.search('112.216.231.90').first
    {
      country: geoinfo&.data['country'],
      city: geoinfo&.data['city'],
      region: geoinfo&.data['region'],
      loc: geoinfo&.data['loc'],
      postal: geoinfo&.data['postal'],
    }
  end

  def filtered_params
    params.except(:controller, :action, :utf8, :authenticity_token, :commit)
  end
end
