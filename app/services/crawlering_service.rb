# frozen_string_literal: true

# require 'singleton'
require 'faraday'
require 'nokogiri'
require 'open-uri'

class CrawleringService
  # include Singleton

  CRIMINAL_RECORD_REPORT_ID = 5 # 전과
  EDUCATION_RECORD_REPORT_ID = 1 # 학력
  ELECTION_ID = "0020200415"

  CACHE_BASE_URL = "https://d27ae9hz5eoziu.cloudfront.net"

  def initialize()
    # @logger = Logger.new(STDOUT)
    @logger = Logger.new("log/#{Rails.env}.log")
  end

  # 선거인수현황 (http://info.nec.go.kr/electioninfo/electionInfo_report.xhtml)
  def crawl_district_detail
    @logger.info('================ crawl_district_detail started ====================')
    
    return if DistrictDetail.last.present?

    # election = Election.find_by(code:2)
    # city = City.find_by(name1: "인천")
    # doc = Nokogiri::HTML(get_district_detail(election.code, city.code))
    # district_details = get_district_detail_table_data(doc)

    election = Election.find_by(code:2)
    election.cities.each do |city|
      doc = Nokogiri::HTML(get_district_detail(election.code, city.code))

      district_details = get_district_detail_table_data(doc)
      district_details.each do |district_detail|
        begin
          electoral_district = district_detail.dig('선거구명').gsub(' ', '')
          district_count = district_detail.dig('읍면동수').to_i
          voting_district_count = district_detail.dig('투표구수').to_i
          population = district_detail.dig('인구수(선거인명부작성기준일 현재)').split('(').first.gsub(',','').to_i
          election_population = district_detail.dig('확정선거인수').split('(').first.gsub(',','').to_i
          absentee = district_detail.dig('거소투표(부재자)신고인명부등재자수').split('(').first.gsub(',','').to_i
          voting_rate = district_detail.dig('인구대비선거인비율(%)').to_f
          households = district_detail.dig('세대수').split('(').first.gsub(',','').to_i

          @logger.info("crawl_district_detail electoral_district: #{electoral_district}")

          voting_district = VotingDistrict.find_by!(name1: electoral_district)


          DistrictDetail.create(voting_district: voting_district,
                                district_count: district_count,
                                voting_district_count: voting_district_count,
                                population: population,
                                election_population: election_population,
                                absentee: absentee,
                                voting_rate: voting_rate,
                                households: households
          )

          # dd = DistrictDetail.find_or_initialize_by(voting_district: voting_district)
          # dd.district_count = district_count
          # dd.voting_district_count = voting_district_count
          # dd.population = population
          # dd.election_population = election_population
          # dd.absentee = absentee
          # dd.voting_rate = voting_rate
          # dd.households = households
          # dd.save!
          
        rescue => e
          @logger.error("error from crawl_district_detail : #{e.message}")
        end
      end

      sleep 5
    end
  end

  # 현재 국회의원 정보 크롤링 (http://info.nec.go.kr/electioninfo/electionInfo_report.xhtml)
  def crawl_latest_congressman
    @logger.info('================ crawl_latest_congressman started ====================')
    return if Congressman.last.present?

    election = Election.find_by(code:2)
    election.cities.each do |city|
      doc = Nokogiri::HTML(get_latest_election_info(election.code, city.code))

      congressmen = get_table_data(doc)
      congressmen.each do |congressman|
        begin
          electoral_district = congressman.dig('선거구명').gsub(' ', '')
          party = congressman.dig('정당명').gsub(' ', '')
          name = congressman.dig('성명(한자)').gsub(' ', '')
          birth_date = congressman.dig('생년월일(연령)').gsub(' ', '')

          c = Congressman.find_or_initialize_by(electoral_district: electoral_district,
                                          party: party,
                                          name: name,
                                          birth_date: birth_date)

          @logger.info("crawl_latest_congressman electoral_district: #{electoral_district}")

          c.voting_district = VotingDistrict.find_by!(name1: electoral_district)
          c.sex = congressman.dig('성별')
          c.job = congressman.dig('직업')
          c.education = congressman.dig('학력')
          c.career = congressman.dig('경력')
          c.voting_rate = congressman.dig('득표수(득표율)')
          c.save!
          
        rescue => e
          @logger.error("error from crawl_latest_congressman : #{e.message}")
        end
      end

      sleep 5
    end
  end

  # 지역 크롤링
  def crawl_districts
    @logger.info('================ crawl_districts started ====================')
    return if District.last.present?

    election = Election.find_by(code:2)
    election.cities.each do |city|
      doc = Nokogiri::HTML(get_district_info(election.code, city.code))
      districts = get_table_data(doc)

      pre_voting_district = nil # 여러 구가 한개의 선거구 일경우 선거구명이 nil 이다
      districts.each do |district|
        @logger.info("crawl_districts voting_district : #{district.dig('선거구명')}")

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


  # # 후보자 id 가져오는 법
  # # 1. 사진 url 에서
  # p = "http://info.nec.go.kr/photo_20200415/Gsg2803/Hb100136586/gicho/thumbnail.100136586.JPG"
  # # 2. 
  # File.basename(p, '.*').gsub('thumbnail.', '')

  # # 후보자 상세 크롤링(전과기록)
  # def get_criminal_report(candidate_id)
  #   candidate_detail_info(CRIMINAL_RECORD_REPORT_ID, candidate_id)
  # end

  # # 후보자 상세 크롤링(학력)
  # def get_education_report(candidate_id)
  #   candidate_detail_info(CRIMINAL_RECORD_REPORT_ID, candidate_id)
  # end

  def candidate_detail_info(report_id, candidate_id)
    headers = Hash.new
    headers['Content-Type'] = 'application/x-www-form-urlencoded; charset=UTF-8'
    url = 'http://info.nec.go.kr/electioninfo/candidate_detail_scanSearchJson.json'
    body = "gubun=#{report_id}&electionId=#{ELECTION_ID}&huboId=#{candidate_id}&statementId=PCRI03_candidate_scanSearch"
    res = http_post_request url, headers, body
    res.body

    return nil unless res.status.eql?(200)
    get_pdf_url(JSON.parse(res.body))
  end

  def get_pdf_url(json)
    tif_path = json.dig('jsonResult', 'body')[0]&.dig('FILEPATH')
    return nil unless tif_path.present?

    pdf_path = "#{File.dirname(tif_path)}/#{File.basename(tif_path, ".*")}.PDF" 
    "http://info.nec.go.kr/unielec_pdf_file/#{pdf_path}"
  end

  def crawlering
    @logger.info("crawlering started!")

    # 지역구 정보 크롤링.
    crawl_districts

    # 지역구 상세 크롤링
    crawl_district_detail

    # 현재 국회의원 정보 크롤링.
    crawl_latest_congressman

    # remove_latest_crawling_date
    TempCandidate.all.destroy_all

    election = Election.find_by(code:2)
    crawl_id = SecureRandom.hex(5)

    election.cities.each do |city|
      city.voting_districts.each do |voting_district|

        # ################### for test
        # city = City.last
        # voting_district = city.voting_districts.last
        # ################### for test

        doc = Nokogiri::HTML(get_election_info(election.code, city.code, voting_district.code))
        candidates = get_candidates(doc)

        temp_candidates = []

        # p candidates
        candidates.each do |candidate|

          electoral_district = candidate.dig('선거구명').gsub(' ', '')
          party = candidate.dig('소속정당명').gsub(' ', '')
          name = candidate.dig('성명(한자)').gsub(' ', '')
          birth_date = candidate.dig('생년월일(연령)').gsub(' ', '')

          c = Candidate.find_or_initialize_by(electoral_district: electoral_district,
          # c = Candidate.find_or_create_by(electoral_district: electoral_district,
                                          party: party,
                                          name: name,
                                          birth_date: birth_date
                                          )
          if c.new_record?
            c.voting_district = voting_district
            c.photo = "http://info.nec.go.kr#{candidate.dig('사진')}"
            c.sex = candidate.dig('성별')
            c.address = candidate.dig('주소')
            c.job = candidate.dig('직업')
            c.education = candidate.dig('학력')
            c.career = candidate.dig('경력')
            c.criminal_record = candidate.dig('전과기록유무(건수)')
            c.reg_date = candidate.dig('등록일자')
            c.crawl_id = crawl_id
            c.candidate_no = File.basename(candidate.dig('사진'), '.*').gsub('thumbnail.', '')
            c.wiki_page = get_namuwiki_page(c.name.split('(').first)
            c.save!

            # 전과 기록
            unless c.criminal_record.include?("없음")
              criminal_pdf_url = candidate_detail_info(CRIMINAL_RECORD_REPORT_ID, c.candidate_no)
              if criminal_pdf_url.present?
                upload_path = "tmp/c_#{c.candidate_no}.pdf"

                # jpg_path = PdfService.instance.convert(upload_path)
                save_photo_info(c, 'criminal', criminal_pdf_url, jpg_path)
              end

              sleep 1
            end

            # 학력
            education_pdf_url = candidate_detail_info(EDUCATION_RECORD_REPORT_ID, c.candidate_no)
            if education_pdf_url.present?
              upload_path = "tmp/e_#{c.candidate_no}.pdf"
              
              # jpg_path = PdfService.instance.convert(upload_path)
              save_photo_info(c, 'education', education_pdf_url, jpg_path)
            end
          else
            # c.photos.each do |photo|
            # end

            temp_candidates.push({
              party: party,
              name: name,
              birth_date: birth_date
            })

            # TempCandidate.create(electoral_district: electoral_district, 
            #                     party: party,
            #                     name: name)
          end
        end

        ## 
        remove_leaved_candidates(voting_district, temp_candidates)
        sleep 4
      end
    end

    # ## Candidate 에는 있고, TempCandidate 는 없는 후보자는 삭제 한다. 
    # remove_leaved_candidates

    @logger.info("crawlering finished!")
    return crawl_id
  rescue => e
    @logger.error("Error : #{e.message}")
  end

  private

  def remove_leaved_candidates(voting_district, temp_candidates)
    Candidate.where(voting_district: voting_district).each do |c1|
      leaved_candidate = true
      temp_candidates.each do |c2|
        if c1.party == c2[:party] && c1.name == c2[:name] && c1.birth_date == c2[:birth_date]
          leaved_candidate = false
          break
        end
      end
      c1.destroy if leaved_candidate == true
    end
    # return if TempCandidate.all.size < 1
    # records_array = ActiveRecord::Base.connection.exec_query("select * from (select candidates.id cid, tmp.id t_cid FROM candidates left outer JOIN temp_candidates tmp ON tmp.electoral_district = candidates.electoral_district and tmp.party = candidates.party and tmp.name = candidates.name) results where results.t_cid is NULL")
    # records_array.each do |record|
    #   Candidate.find(record.dig('cid')).destroy
    # end
  end

  def save_photo_info(candidate, photo_type, origin_url, upload_path)
    begin
      UploadService.instance.upload(origin_url, upload_path)
      candidate.photos.create(photo_type: photo_type, url: "#{CACHE_BASE_URL}/#{upload_path}") 
    rescue => exception
      @logger.info("upload s3 error : #{origin_url}")
      candidate.photos.create(photo_type: photo_type, url: origin_url) 
    end
  end

  def get_namuwiki_page(username)
    url = "https://namu.wiki/w/#{URI.encode(username)}"
    res = http_get_request(url)
    return res.status.eql?(200)? url : ''
  end

  def remove_latest_crawling_date
    Candidate.where.not(crawl_id: Candidate.last&.crawl_id).destroy_all
  end

  def get_district_detail_table_data(doc)
    table = doc.search('.table01')
    column_names = table.css('thead tr th').map(&:text)
    # print column_names

    rows = table.css('tbody tr')

    # 3행씩 짝이다.
    # 3행의 첫번째 행만 읽으면 된다. (단 3행의 첫번째 td 값(선거구명)이 있어야 한다. => 선거구가 없는 행은 선거구가 여러 "구시군명" 이 합쳐서 하나의 선거구 일때 이다)
    # text_all_rows = rows.each_slice(3) do |array_of_3_items|
    text_all_rows = rows.each_slice(3).map do |array_of_3_items|

      # 첫번째 td
      first_td_text = array_of_3_items.first.css('td')&.first&.text
      next if first_td_text.blank? || first_td_text.eql?('합계')

      row_values = []
      array_of_3_items.first.css('td').each do |r|
        value = r.text.gsub(/\t|\n|\r/, '') 
        next if value.eql?('계')
        row_values << value
      end

      row_values.compact
    end
    text_all_rows = text_all_rows.compact

    # text_all_rows = rows.map do |row|
    #   # 3 행씩 짝이다.
    #   #  3행의 첫 행이 "계"(합계) 내용이다.
    #   #  선거구명은 중간 행에 있고, 선거구가 없는 행은 선거구가 여러 "구시군명" 이 합쳐서 하나의 선거구 일때 이다.
    #   # ######################
    #   # if row.css('td')&.first&.text == '' || row.css('td')&.first&.text == '합계' 
    #   #   next
    #   # end
    #   # ######################
    #   row_values = []
    #   row.css('td').each do |r|
    #     row_values << r.text.gsub(/\t|\n|\r/, '')
    #   end

    #   row_values
    # end
    column_datas = []
    text_all_rows.each do |row_as_text|
       column_datas << column_names.zip(row_as_text).to_h
    end # =>

    column_datas
  end

  def get_table_data(doc)
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

    column_datas = []
    text_all_rows.each do |row_as_text|
       column_datas << column_names.zip(row_as_text).to_h
    end # =>

    column_datas
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

  def get_district_detail(election_code, city_code)
    headers = Hash.new
    headers['Content-Type'] = 'application/x-www-form-urlencoded'
  
    url = 'http://info.nec.go.kr/electioninfo/electionInfo_report.xhtml'
    body = "electionId=0000000000&requestURI=/WEB-INF/jsp/electioninfo/0000000000/cd/cdpb02.jsp&topMenuId=CD&statementId=CDPB02_#3_2_1&oldElectionType=1&electionName=20160413&electionType=2&searchType=3&electionCode=#{election_code}&electionName=20160413&cityCode=#{city_code}&sggCityCode=-1&townCode=-1"
    res = http_post_request url, headers, body
    res.body
  end

  def get_latest_election_info(election_code, city_code)
    headers = Hash.new
    headers['Content-Type'] = 'application/x-www-form-urlencoded'
  
    url = 'http://info.nec.go.kr/electioninfo/electionInfo_report.xhtml'
    body = "electionId=0000000000&requestURI=/WEB-INF/jsp/electioninfo/0000000000/ep/epei01.jsp&topMenuId=EP&statementId=EPEI01_#1&oldElectionType=1&electionType=2&electionCode=#{election_code}&electionName=20160413&cityCode=#{city_code}"
    res = http_post_request url, headers, body
    res.body
  end

  def get_district_info(election_code, city_code)
    headers = Hash.new
    headers['Content-Type'] = 'application/x-www-form-urlencoded'
  
    # file = File.open('/Users/hyungsungshim/Workspace/myproject/ssm/v2020/a.html', "r")
    # data = file.read
    # file.close
    # data
    url = 'http://info.nec.go.kr/electioninfo/electionInfo_report.xhtml'
    body = "electionId=#{ELECTION_ID}&requestURI=/WEB-INF/jsp/electioninfo/#{ELECTION_ID}/bi/bigi05.jsp&topMenuId=BI&statementId=BIGI05_2&electionCode=#{election_code}&cityCode=#{city_code}"
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
    body = "electionId=#{ELECTION_ID}&requestURI=/WEB-INF/jsp/electioninfo/#{ELECTION_ID}/pc/pcri03_ex.jsp&topMenuId=PC&statementId=PCRI03_#2&electionCode=#{election_code}&cityCode=#{city_code}&sggCityCode=#{sgg_city_codes}"
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
      @logger.error("http_get_request error : #{e}")
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
      @logger.error("http_post_request error : #{e}")
      raise Exception.new "http_post_request error url : #{url}"
    end
    res
  end
end
