class ApplicationController < ActionController::API

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
end
