# frozen_string_literal: true

# require 'singleton'
require 'faraday'

class KakaoLocationService
  # include Singleton

  API_URL = "https://dapi.kakao.com/v2/local/geo/coord2address.json"
  AUTORIZATION_HEADER = "KakaoAK aaebc65e6dd5021b19da8251a4b2adc9"

  def initialize()
    # @logger = Logger.new(STDOUT)
  end

  def get_location_info(x, y)
    headers = Hash.new
    headers['Authorization'] = AUTORIZATION_HEADER
    url = "#{API_URL}?x=#{x}&y=#{y}"
    res = http_get_request url, headers
    return nil unless res.status.eql?(200)

    Rails.logger.info("get_location_info : #{res.body}")
    res.body
  end


  private 

  def http_get_request (url, headers = {})
    con = Faraday.new
    begin
      res = con.get do |req|
        req.url url
        req.headers = headers
        req.options.timeout = 10
      end
    rescue Faraday::Error => e
      Rails.logger.error("http_get_request error : #{e}")
      raise Exception.new "http_get_request error url : #{url}"
    end
  end

end
