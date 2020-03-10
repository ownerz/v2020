class ApplicationController < ActionController::API

  def set_district

    return if (params[:x].present? && params[:y].present?) == false
    location_string = KakaoLocationService.new.get_location_info(params[:x], params[:y])
    return unless location_string.present?

    #
    # 세종은 특별하다.
    # "region_1depth_name"=>"세종특별자치시", "region_2depth_name"=>"세종시", "region_3depth_name"=>"연서면 와촌리"
    # 제주도 특별하다.
    # "region_1depth_name"=>"제주특별자치도", "region_2depth_name"=>"제주시", "region_3depth_name"=>"애월읍 고성리"
    #

    region_1depth_name = JSON.parse(location_string).dig('documents')[0]&.dig('address')&.dig('region_1depth_name')
    region_2depth_name = JSON.parse(location_string).dig('documents')[0]&.dig('address')&.dig('region_2depth_name')
    region_3depth_name = JSON.parse(location_string).dig('documents')[0]&.dig('address')&.dig('region_3depth_name')
    return unless region_1depth_name.present? || region_2depth_name.present?

    @district = District.where('name1 like ?', "#{region_3depth_name.split(' ').first}%")&.first&.voting_district

    if @district.blank?
      @district = VotingDistrict.where('name1 like ?', "#{region_2depth_name}%")
      @district = VotingDistrict.where('name2 like ?', "#{region_2depth_name}%") unless @district.present?
      @district = VotingDistrict.where('name1 like ?', "#{region_1depth_name}%") unless @district.present?
      @district = VotingDistrict.where('name2 like ?', "#{region_1depth_name}%") unless @district.present?
      @district = @district.where(city: City.where(name1: region_1depth_name)).first if @district.present?
    end

    Rails.logger.info("get_district) district: #{@district}")
  end

  def get_page_info(object)
    return nil unless (object && object.respond_to?(:current_page))

    {
        current_page: object.current_page,
        next_page: object.next_page == nil ? 0 : object.next_page,
        prev_page: object.prev_page == nil ? 0 : object.prev_page,
        total_page: object.total_pages == nil ? 0 : object.total_pages,
        total_count: object.total_count == nil ? 0 : object.total_count
    }
  end

  def meta_status(result: 'ok', code: 0, alert_type: 0, result_msg: '')
    {
      result: result,
      code: code,
      alert_type: alert_type,
      result_msg: result_msg
    }
  end

  def default_meta
    {}
  end

  def set_meta
    @meta = meta_status
  end

  def render_response(resource: {}, meta: {})
    meta = meta.merge(meta_status)
    render json: resource.merge({meta: meta})
  end

  def render_error(status, message, data = nil)
    message = message.full_messages.first if message.respond_to?('full_messages')
    response = {
      result: 'fail',
      code: -1,
      alert_type: 1,
      result_msg: message
    }
    response = response.merge(data) if data
    render json: {meta: response}, status: status
  end

end
