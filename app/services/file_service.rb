require 'singleton'
require 'net/http'
require 'open-uri'

class FileService
  include Singleton

  def initialize()
    @s3 = Aws::S3::Client.new(
      region: Rails.application.credentials.aws_admin_s3[:region],
      access_key_id: Rails.application.credentials.aws_admin_s3[:access_key_id], 
      secret_access_key: Rails.application.credentials.aws_admin_s3[:secret_access_key]
    )
  end

  def download(target_path, image_url)
    # target_path = '/home/ec2-user/image.pdf'
    # image_url = "https://d27ae9hz5eoziu.cloudfront.net/tmp/e_100136749.pdf"
    open(target_path, 'wb') do |file|
      file << open(image_url).read
    end
  end

  def upload(origin_file, save_path)

    begin
      file = File.open(origin_file, "r")
      file_data = file.read
      file.close

      resp = @s3.put_object(
        # acl: "public-read", 
        body: file_data, 
        bucket: "ssm-admin", 
        key: "#{save_path}",
      )

    rescue Aws::S3::Errors => ex
      Rails.logger.error("s3 upload error #{ex.message}")

    rescue => e
      Rails.logger.error("s3 upload error #{e}")
    end

  end

  def direct_upload(origin_url, save_path)
    # url = URI("https://www.google.com/images/srpr/logo3w.png")
    url = URI(origin_url)
    Net::HTTP.start(url.host) do |http|
      resp = http.get(url.path)
      begin
        resp = @s3.put_object(
          # acl: "public-read", 
          body: resp.body, 
          bucket: "ssm-admin", 
          key: "#{save_path}",
        )

      rescue Aws::S3::Errors => ex
        Rails.logger.error("s3 upload error #{ex.message}")
      end

    end
  end
end
