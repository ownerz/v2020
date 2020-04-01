# frozen_string_literal: true

module ApplicationHelper

  def site_name(name = nil)
    default = 'V2020'

    if name.present?
      @site_title = name
    end

    @site_title || default
  end

  def page_title(*titles)
    @page_title ||= []
    @page_title.push(*titles.compact) if titles.any?
    @page_title.join(' \u00b7 ')
  end

  def favicon
    'favicon.ico'
  end

  # 각종 List 화면에서 번호를 지정할 때 사용하는 구문 @jpseo 딜리버드 주문 카운트 컬럼명 중복으로 데이터가 나오지 않아 주석 처리
  #def item_count(count, param = :page)
  #  ((params[param] || 1).to_i * (params[:per] || 25).to_i - (params[:per] || 25).to_i) + count + 1
  #end

  def get_filename(url)
    uri = Addressable::URI.parse(url)
    File.basename(uri.path)
  end

  def format_datetime(arg)
    # arg && arg.is_a(DateTime) ? arg.strftime('%Y-%m-%d') : '-'
    arg ? arg.strftime('%Y-%m-%d') : '-'
  end

  def nl2br(s)
    return '' unless s
    s.gsub(/\n/, '<br />').html_safe
  end

  def favicon
    Rails.env.development? ? 'favicon-blue.ico' : 'favicon.ico'
  end

  def valid_json?(json)
    !!JSON.parse(json)
  rescue JSON::ParserError => _e
    false
  end

  ###############

  def is_active_controller(controller_name, class_name = nil)
    if params[:controller] == controller_name
     class_name == nil ? "active" : class_name
    else
       nil
    end
  end

  def is_active_action(action_name)
      params[:action] == action_name ? "active" : nil
  end

  def asset_exists?(subdirectory, filename)
    File.exists?(File.join(Rails.root, 'app', 'assets', subdirectory, filename))
  end

  def image_exists?(image)
    asset_exists?('images', image)
  end

  def javascript_exists?(script)
    extensions = %w(.coffee .erb .coffee.erb) + [""]
    extensions.inject(false) do |truth, extension|
      truth || asset_exists?('javascripts', "#{script}.js#{extension}")
    end
  end

  def stylesheet_exists?(stylesheet)
    extensions = %w(.scss .erb .scss.erb) + [""]
    extensions.inject(false) do |truth, extension|
      truth || asset_exists?('stylesheets', "#{stylesheet}.css#{extension}")
    end
  end
###########
end
