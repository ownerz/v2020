# frozen_string_literal: true

# require 'singleton'
require 'faraday'
require 'nokogiri'
require 'open-uri'

class CrawleringService
  # include Singleton

  def initialize()
    @logger = Logger.new(STDOUT)
  end

  def crawl_districts
    return if District.last.present?

    election = Election.find_by(code:2)
    election.cities.each do |city|
      doc = Nokogiri::HTML(get_district_info(election.code, city.code))
      districts = get_districts(doc)

      pre_voting_district = nil # 여러 구가 한개의 선거구 일경우 선거구명이 nil 이다
      districts.each do |district|
        voting_district = VotingDistrict.find_by(name1: district.dig('선거구명'))
        voting_district = pre_voting_district unless voting_district.present?
        voting_district.name2 = district.dig('구시군명')
        voting_district.save!
        pre_voting_district = voting_district

        district.dig('읍면동명').split(',').each do |name|
          voting_district.districts.create(code: 0, name1: name.gsub(' ', ''))
        end
      end
      sleep 5
    end
  end

  def crawlering
    crawl_districts
    remove_latest_crawling_date

    election = Election.find_by(code:2)
    crawl_id = SecureRandom.hex(5)

    election.cities.each do |city|
      city.voting_districts.each do |district|
        doc = Nokogiri::HTML(get_election_info(election.code, city.code, district.code))
        candidates = get_candidates(doc)

        # p candidates
        candidates.each do |candidate|
          c = Candidate.find_or_initialize_by(electoral_district: candidate.dig('선거구명').gsub(' ', ''), 
                                          party: candidate.dig('소속정당명').gsub(' ', ''),
                                          name: candidate.dig('성명(한자)').gsub(' ', ''),
                                          birth_date: candidate.dig('생년월일(연령)').gsub(' ', '')
                                          )
          if c.new_record?
            c.voting_district = district
            c.photo = "http://info.nec.go.kr/#{candidate.dig('사진')}"
            c.sex = candidate.dig('성별')
            c.address = candidate.dig('주소')
            c.job = candidate.dig('직업')
            c.education = candidate.dig('학력')
            c.career = candidate.dig('경력')
            c.criminal_record = candidate.dig('전과기록유무(건수)')
            c.reg_date = candidate.dig('등록일자')
            c.crawl_id = crawl_id
            c.wiki_page = get_namuwiki_page(c.name.split('(').first)
          end
          c.save!
          sleep 2
        end
      end
    end

    return crawl_id
  end

  private

  def get_namuwiki_page(username)
    url = "https://namu.wiki/w/#{URI.encode(username)}"
    res = http_get_request(url)
    return res.status.eql?(200)? url : ''
  end

  def remove_latest_crawling_date
    Candidate.where.not(crawl_id: Candidate.last.crawl_id).destroy_all
  end

  def get_districts(doc)
    table = doc.search('.table01')
  
    column_names = table.css('thead tr th').map(&:text)
    # print column_names
  
    rows = table.css('tbody tr')
    text_all_rows = rows.map do |row|
      row_values = []
      row.css('td').each do |r|
        row_values << r.text.gsub(/\t|\n|\r/, '')
      end
      row_values
    end

    districts = []
    text_all_rows.each do |row_as_text|
       districts << column_names.zip(row_as_text).to_h
    end # =>

    districts
  end

  def get_candidates(doc)
    table = doc.search('.table01')
  
    column_names = table.css('thead tr th').map(&:text)
    # print column_names
  
    rows = table.css('tbody tr')
    text_all_rows = rows.map do |row|
      row_values = []
      row.css('td').each do |r|
        if r.css('input').empty? # 일반 column
          row_values << r.text.gsub(/\t|\n|\r/, '')
        else  # photo
          row_values << r.at_css('input').attr('src')
        end
      end
      row_values
    end
  
    candidates = []
    text_all_rows.each do |row_as_text|
       candidates << column_names.zip(row_as_text).to_h
    end # =>

    candidates
  end

  def get_district_info(election_code, city_code)
    headers = Hash.new
    headers['Content-Type'] = 'application/x-www-form-urlencoded'
  
    # file = File.open('/Users/hyungsungshim/Workspace/myproject/ssm/v2020/a.html', "r")
    # data = file.read
    # file.close
    # data
    url = 'http://info.nec.go.kr/electioninfo/electionInfo_report.xhtml'
    body = "electionId=0020200415&requestURI=/WEB-INF/jsp/electioninfo/0020200415/bi/bigi05.jsp&topMenuId=BI&statementId=BIGI05_2&electionCode=#{election_code}&cityCode=#{city_code}"
    res = http_post_request url, headers, body
    res.body
  end

  def get_election_info(election_code, city_code, sgg_city_codes)
    headers = Hash.new
    headers['Content-Type'] = 'application/x-www-form-urlencoded'
  
    # file = File.open('/Users/hyungsungshim/Workspace/myproject/ssm/v2020/a.html', "r")
    # data = file.read
    # file.close
    # data
    url = 'http://info.nec.go.kr/electioninfo/electionInfo_report.xhtml'
    body = "electionId=0020200415&requestURI=/WEB-INF/jsp/electioninfo/0020200415/pc/pcri03_ex.jsp&topMenuId=PC&statementId=PCRI03_#2&electionCode=#{election_code}&cityCode=#{city_code}&sggCityCode=#{sgg_city_codes}"
    res = http_post_request url, headers, body
    res.body
  end

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
    res
  end

  def http_post_request(url, headers = {}, body)
    con = Faraday.new
    begin
      res = con.post do |req|
        req.url url
        req.headers = headers
        req.options.timeout = 10
        req.body = body
      end
    rescue Faraday::Error => e
      Rails.logger.error("http_post_request error : #{e}")
      raise Exception.new "http_post_request error url : #{url}"
    end
    res
  end
end
