require 'singleton'
require 'net/http'

class UploadService
  include Singleton

  def initialize()
    @s3 = Aws::S3::Client.new(
      region: Rails.application.credentials.aws_admin_s3[:region],
      access_key_id: Rails.application.credentials.aws_admin_s3[:access_key_id], 
      secret_access_key: Rails.application.credentials.aws_admin_s3[:secret_access_key]
    )
  end

  def upload(origin_url, candidate_no)
    # url = URI("https://www.google.com/images/srpr/logo3w.png")
    url = URI(origin_url)
    Net::HTTP.start(url.host) do |http|
      resp = http.get(url.path)
      begin
        resp = @s3.put_object(
          # acl: "public-read", 
          body: resp.body, 
          bucket: "ssm-admin", 
          key: "tmp/#{candidate_no}",
        )

        # https://d27ae9hz5eoziu.cloudfront.net/tmp/100136897
      rescue Aws::S3::Errors => ex
        Rails.logger.error("s3 upload error #{ex.message}")
      end

    end
  end
end
