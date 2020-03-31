# frozen_string_literal: true

# require 'singleton'
require 'faraday'
require 'nokogiri'
require 'open-uri'

## 
# 비례당당
# code 정당명
# ----------------
# 100  더불어민주당
# 200  미래통합당
# 2080 민생당
# 5037 미래한국당
# 5048 더불어시민당
# 730  정의당
# 5000 우리공화당
# 5010 민중당
# 3060 한국경제당
# 5040 국민의당
# 5044 친박신당
# 5049 열린민주당
# 1970 코리아
# 3070 가자!평화인권당
# 5039 가자환경당
# 2010 공화당
# 5031 국가혁명배당금당
# 4080 국민새정당
# 2070 국민참여신당
# 2020 기독당
# 3040 기독자유통일당
# 5035 기본소득당
# 5052 깨어있는시민연대당
# 5051 남북통일당
# 1988 노동당
# 710  녹색당
# 3010 대한당
# 650  대한민국당
# 4040 미래당
# 5047 미래민주당
# 1980 미래자영업당
# 4010 민중민주당
# 700  사이버모바일국민정책당
# 4070 새누리당
# 5042 시대전환
# 5046 여성의당
# 5053 우리당
# 5043 자유당
# 5030 새벽당
# 5050 정치개혁연합
# 5045 자영업당
# 5033 직능자영업당
# 5041 충청의미래당
# 2000 친박연대
# 2060 통일민주당
# 4000 통합민주당
# 2050 한국국민당
# 3000 한국복지당
# 1990 한나라당
# 3050 한반도미래연합
# 4060 홍익당

class CrawleringService
  # include Singleton

  ELECTION_ID = "0020200415"
  EDUCATION_RECORD_REPORT_ID = 1 # 학력
  PROPERTY_RECORD_REPORT_ID = 2 # 재산
  TAX_RECORD_REPORT_ID = 3 # 납세
  MILITARY_RECORD_REPORT_ID = 4 # 병역
  CRIMINAL_RECORD_REPORT_ID = 5 # 전과
  ELECTION_RECORD_REPORT_ID = 8 # 공직선거 경력

  CACHE_BASE_URL = "https://d27ae9hz5eoziu.cloudfront.net"

  def initialize()
    # @logger = Logger.new(STDOUT)
    @logger = Logger.new("log/#{Rails.env}.log")
  end

  ###################################
  # 
  def convert_pdf_to_png_manually
    Candidate.all.each do |candidate|
      candidate.photos.each do |photo|

        next unless File.extname(photo.url).eql?(".pdf")

        photo_type = photo.photo_type
        pdf_url = photo.url

        begin
          @logger.info("pdf_to_png] pdf url : #{pdf_url}")

          # 1. pdf_url 에서 /tmp 폴더로 다운로드
          tmp_path = "/tmp/#{photo_type}_#{candidate.candidate_no}.pdf"
          FileService.instance.download(tmp_path, pdf_url)
          @logger.info("pdf_to_png] #{pdf_url} 다운로드 성공: #{tmp_path}")

          # 2. /tmp 에 있는 pdf -> png 로 변환
          png_path = PdfService.new.convert(tmp_path)
          @logger.info("pdf_to_png] png_path : #{png_path}")

          # 3. png -> s3 로 upload
          s3_path = "tmp/#{photo_type}_#{candidate.candidate_no}.png"
          FileService.instance.upload(png_path, s3_path)

          @logger.info("pdf_to_png] s3 path: #{s3_path}")

          photo.update(url: "#{CACHE_BASE_URL}/#{s3_path}")

          File.delete(tmp_path) 
          File.delete(tmp_path.ext('png')) 

        rescue => e
          @logger.error("이미지 저장 실패 : #{e.message} \n")
        end
      end
    end
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

  def save_photos(c)
    # 학력
    unless c.education_photos.present?
      pdf_url = candidate_detail_info(EDUCATION_RECORD_REPORT_ID, c.candidate_no)
      save_photo_info(c, 'e', pdf_url) if pdf_url.present?
      sleep 1
    end

    # 재산
    unless c.property_photos.present?
      pdf_url = candidate_detail_info(PROPERTY_RECORD_REPORT_ID, c.candidate_no)
      save_photo_info(c, 'p', pdf_url) if pdf_url.present?
      sleep 1
    end

    # 납세
    unless c.tax_photos.present?
      pdf_url = candidate_detail_info(TAX_RECORD_REPORT_ID, c.candidate_no)
      save_photo_info(c, 't', pdf_url) if pdf_url.present?
      sleep 1
    end

    # 병역
    unless c.military_photos.present?
      pdf_url = candidate_detail_info(MILITARY_RECORD_REPORT_ID, c.candidate_no)
      save_photo_info(c, 'm', pdf_url) if pdf_url.present?
      sleep 1
    end

    # 전과 기록
    unless c.criminal_photos.present?
      unless c.criminal_record.include?("없음")
        pdf_url = candidate_detail_info(CRIMINAL_RECORD_REPORT_ID, c.candidate_no)
        if pdf_url.present?

          # save_photo(c, 'c', criminal_pdf_url)
          # jpg_path = PdfService.new.convert(upload_path)
          # save_photo_info(c, 'c', criminal_pdf_url, upload_path)

          save_photo_info(c, 'c', pdf_url)
        end

        sleep 1
      end
    end

    # 공직선거 경력
    unless c.election_photos.present?
      pdf_url = candidate_detail_info(ELECTION_RECORD_REPORT_ID, c.candidate_no)
      save_photo_info(c, 'el', pdf_url) if pdf_url.present?
      sleep 1
    end
  end

  # 비례대표 크롤링 (http://info.nec.go.kr/electioninfo/electionInfo_report.xhtml)
  def proportional_party
    PoliticalParty.all.each do |pp|

      doc = Nokogiri::HTML(get_proportional_info(7, pp.code))
      candidates = get_proportional_candidates(doc)
      next if candidates&.first&.dig('선거구명') == '검색된 결과가 없습니다.'

      begin
        candidates.each do |candidate|
          # '선거구명' # 비례정당
          # candidate.dig('사진') 
          # candidate.dig('소속정당명(기호)') 
          # candidate.dig('추천순위') 
          # candidate.dig('성명(한자)') 
          # candidate.dig('성별') 
          # candidate.dig('생년월일(연령)') 
          # candidate.dig('주소') 
          # candidate.dig('직업') 
          # candidate.dig('학력') 
          # candidate.dig('경력') 
          # candidate.dig('재산신고액(천원)') 
          # candidate.dig('병역신고사항(본인)') 
          # candidate.dig('납부액') 
          # candidate.dig('최근5년간체납액') 
          # candidate.dig('현체납액') 
          # candidate.dig('전과기록유무(건수)') 
          # candidate.dig('입후보횟수')

          electoral_district = candidate.dig('선거구명').gsub(' ', '')
          party_array = candidate.dig('소속정당명(기호)').gsub(' ', '').gsub(')', '').split('(')
          name = candidate.dig('성명(한자)').gsub(' ', '')
          birth_date = candidate.dig('생년월일(연령)').gsub(' ', '')

          c = Candidate.find_or_initialize_by(electoral_district: '비례정당',
                                          party: party_array[0],
                                          name: name,
                                          birth_date: birth_date)
          # if c.new_record?
            c.political_party = PoliticalParty.find_by(name1: party_array[0])
            if c.political_party.present?
              c.political_party.number = party_array[1].to_i
              c.political_party.save!
            end

            c.candidate_type = :proportional
            c.party_number = party_array[1].to_i # 정당 기호
            # c.voting_district = voting_district
            c.photo = "http://info.nec.go.kr#{candidate.dig('사진')}"
            c.sex = candidate.dig('성별')
            c.address = candidate.dig('주소')
            c.job = candidate.dig('직업')
            c.education = candidate.dig('학력')
            c.career = candidate.dig('경력')
            c.criminal_record = candidate.dig('전과기록유무(건수)')
            c.number = candidate.dig('추천순위')
            c.property = candidate.dig('재산신고액(천원)')
            c.military = candidate.dig('병역신고사항(본인)')
            c.candidate_number = candidate.dig('입후보횟수')
            c.tax_payment = candidate.dig('납부액')
            c.latest_arrears = candidate.dig('최근5년간체납액')
            c.arrears = candidate.dig('현체납액')
            c.candidate_no = File.basename(candidate.dig('사진'), '.*').gsub('thumbnail.', '')
            c.wiki_page = get_namuwiki_page(c.name.split('(').first)
            c.save!

            save_photos(c)
            @logger.info("크롤된 후보자 : #{c.party} 당의 #{name} ")
          # else
          #   # update updated_at
          #   c.touch
          # end
        end
      end
      sleep 15
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
    # body = "gubun=#{report_id}&electionId=#{ELECTION_ID}&huboId=#{candidate_id}&statementId=PCRI03_candidate_scanSearch"
    body = "gubun=#{report_id}&electionId=#{ELECTION_ID}&huboId=#{candidate_id}&statementId=CPRI03_candidate_scanSearch"
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
    # crawl_id = SecureRandom.hex(5)

    election.cities.each do |city|
      city.voting_districts.each do |voting_district|

        # ################### for test
        # city = City.last
        # voting_district = city.voting_districts.last
        # ################### for test

        # 메인 화면 (시도->선거구->검색)
        doc = Nokogiri::HTML(get_election_info(election.code, city.code, voting_district.code))
        candidates = get_candidates(doc)
        begin
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
              # c.reg_date = candidate.dig('등록일자')
              # c.crawl_id = crawl_id

              c.number = candidate.dig('기호')
              c.property = candidate.dig('재산신고액(천원)')
              c.military = candidate.dig('병역신고사항(본인)')
              c.candidate_number = candidate.dig('입후보횟수')
              c.tax_payment = candidate.dig('납부액')
              c.latest_arrears = candidate.dig('최근5년간체납액')
              c.arrears = candidate.dig('현체납액')

              c.candidate_no = File.basename(candidate.dig('사진'), '.*').gsub('thumbnail.', '')
              c.wiki_page = get_namuwiki_page(c.name.split('(').first)
              c.save!

              @logger.info("#{electoral_district} 선거구의 #{party} #{name} 후보자 등록")
              save_photos(c)

              # # 학력
              # unless c.education_photos.present?
              #   pdf_url = candidate_detail_info(EDUCATION_RECORD_REPORT_ID, c.candidate_no)
              #   save_photo_info(c, 'e', pdf_url) if pdf_url.present?
              #   sleep 1
              # end

              # # 재산
              # unless c.property_photos.present?
              #   pdf_url = candidate_detail_info(PROPERTY_RECORD_REPORT_ID, c.candidate_no)
              #   save_photo_info(c, 'p', pdf_url) if pdf_url.present?
              #   sleep 1
              # end

              # # 납세
              # unless c.tax_photos.present?
              #   pdf_url = candidate_detail_info(TAX_RECORD_REPORT_ID, c.candidate_no)
              #   save_photo_info(c, 't', pdf_url) if pdf_url.present?
              #   sleep 1
              # end

              # # 병역
              # unless c.military_photos.present?
              #   pdf_url = candidate_detail_info(MILITARY_RECORD_REPORT_ID, c.candidate_no)
              #   save_photo_info(c, 'm', pdf_url) if pdf_url.present?
              #   sleep 1
              # end

              # # 전과 기록
              # unless c.criminal_photos.present?
              #   unless c.criminal_record.include?("없음")
              #     pdf_url = candidate_detail_info(CRIMINAL_RECORD_REPORT_ID, c.candidate_no)
              #     if pdf_url.present?

              #       # save_photo(c, 'c', criminal_pdf_url)
              #       # jpg_path = PdfService.new.convert(upload_path)
              #       # save_photo_info(c, 'c', criminal_pdf_url, upload_path)

              #       save_photo_info(c, 'c', pdf_url)
              #     end

              #     sleep 1
              #   end
              # end

              # # 공직선거 경력
              # unless c.election_photos.present?
              #   pdf_url = candidate_detail_info(ELECTION_RECORD_REPORT_ID, c.candidate_no)
              #   save_photo_info(c, 'el', pdf_url) if pdf_url.present?
              #   sleep 1
              # end

              @logger.info("크롤된 후보자 : #{electoral_district} 선거구의 #{party} #{name} ")
              # temp_candidates.push({
              #   party: party,
              #   name: name,
              #   birth_date: birth_date
              # })
              # TempCandidate.create(electoral_district: electoral_district, 
              #                     party: party,
              #                     name: name)
            else
              # update updated_at
              c.touch
            end
          end

          ## 
          # remove_leaved_candidates(voting_district, temp_candidates)
          sleep 12

        rescue => e
          @logger.error("후보 등록 오류 : #{e.message}")
        end
      end
    end

    # ## Candidate 에는 있고, TempCandidate 는 없는 후보자는 삭제 한다. 
    remove_leaved_candidates
    @logger.info("crawlering finished!")
    # return crawl_id
    return ''
  rescue => e
    @logger.error("Error : #{e.message}")
  end

  private

  def remove_leaved_candidates(voting_district, temp_candidates)
    # Candidate.where('updated_at >= ?', 3.days.ago).destroy_all
    Candidate.where('updated_at <= ?', 3.days.ago).each do |candidate|
      @logger.info("remove_leaved_candidates] #{candidate.name} 삭제")
    end
  end

  # def remove_leaved_candidates(voting_district, temp_candidates)
  #   # Candidate.where(voting_district: voting_district).each do |c1|
  #   Candidate.where(voting_district: voting_district).where.not(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).each do |c1|
  #     leaved_candidate = true
  #     temp_candidates.each do |c2|
  #       if c1.party == c2[:party] && c1.name == c2[:name] && c1.birth_date == c2[:birth_date]
  #         leaved_candidate = false
  #         break
  #       end
  #     end

  #     if leaved_candidate == true
  #       @logger.info("remove_leaved_candidates] #{c1.name} 삭제")
  #       c1.destroy 
  #     end
  #   end

  #   # return if TempCandidate.all.size < 1
  #   # records_array = ActiveRecord::Base.connection.exec_query("select * from (select candidates.id cid, tmp.id t_cid FROM candidates left outer JOIN temp_candidates tmp ON tmp.electoral_district = candidates.electoral_district and tmp.party = candidates.party and tmp.name = candidates.name) results where results.t_cid is NULL")
  #   # records_array.each do |record|
  #   #   Candidate.find(record.dig('cid')).destroy
  #   # end
  # end

  def save_photo_info(candidate, photo_type, pdf_url)
    begin
      # s3_path = "tmp/#{photo_type}_#{candidate.candidate_no}.pdf"
      # FileService.instance.direct_upload(pdf_url, s3_path)
      # candidate.photos.create(photo_type: photo_type, url: "#{CACHE_BASE_URL}/#{s3_path}") 

      candidate.photos.create(photo_type: photo_type, url: pdf_url) 
    rescue => exception
      @logger.error("upload s3 error : #{pdf_url}")
      candidate.photos.create(photo_type: photo_type, url: pdf_url) 
    end
  end

  def save_photo(candidate, photo_type, pdf_url)
    begin
      # 1. pdf_url 에서 /tmp 폴더로 다운로드
      tmp_path = "/tmp/#{photo_type}_#{candidate.candidate_no}.pdf"
      FileService.instance.download(tmp_path, pdf_url)

      # 2. /tmp 에 있는 pdf -> png 로 변환
      png_path = PdfService.new.convert(tmp_path)

      # 3. png -> s3 로 upload
      s3_path = "tmp/#{photo_type}_#{candidate.candidate_no}.png"
      FileService.instance.upload(png_path, s3_path)

      candidate.photos.create(photo_type: photo_type, url: "#{CACHE_BASE_URL}/#{s3_path}") 

      File.delete(tmp_path) 
      File.delete(tmp_path.ext('png')) 
    rescue => e
      @logger.error("전과 기록 이미지 오류 : #{e.message}")
      candidate.photos.create(photo_type: photo_type, url: pdf_url) 
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

  # 비례 후보자 크롤링.
  # electionId: 0020200415
  # requestURI: /WEB-INF/jsp/electioninfo/0020200415/cp/cpri03.jsp
  # topMenuId: CP
  # secondMenuId: CPRI03
  # menuId: CPRI03
  # statementId: CPRI03_#7
  # electionCode: 7
  # cityCode: -1
  # sggCityCode: -1
  # proportionalRepresentationCode: 5037
  # townCode: -1
  # sggTownCode: 0
  # dateCode: 0
  # x: 30
  # y: 11
  def get_proportional_info(election_code, proportionalRepresentationCode)
    headers = Hash.new
    headers['Content-Type'] = 'application/x-www-form-urlencoded'
    url = 'http://info.nec.go.kr/electioninfo/electionInfo_report.xhtml'
    body = "electionId=#{ELECTION_ID}&requestURI=/WEB-INF/jsp/electioninfo/#{ELECTION_ID}/cp/cpri03.jsp&topMenuId=CP&statementId=CPRI03_#7&electionCode=#{election_code}&cityCode=-1&sggCityCode=-1&proportionalRepresentationCode=#{proportionalRepresentationCode}"
    # body = "electionId=#{ELECTION_ID}&requestURI=/WEB-INF/jsp/electioninfo/#{ELECTION_ID}/pc/pcri03_ex.jsp&topMenuId=PC&statementId=PCRI03_#2&electionCode=#{election_code}&cityCode=#{city_code}&sggCityCode=#{sgg_city_codes}"
    res = http_post_request url, headers, body
    res.body
  end

  # 비례 후보자 list 출력.
  def get_proportional_candidates(doc)
    table = doc.search('.table01')
    column_names = ["선거구명", 
                    "사진", 
                    "소속정당명(기호)", 
                    "추천순위", 
                    "성명(한자)", 
                    "성별", 
                    "생년월일(연령)", 
                    "주소", 
                    "직업", 
                    "학력", 
                    "경력", 
                    "재산신고액(천원)", 
                    "병역신고사항(본인)", 
                    "납부액", 
                    "최근5년간체납액", 
                    "현체납액", 
                    "전과기록유무(건수)", 
                    "입후보횟수"]

    rows = table.css('tbody tr')
    text_all_rows = rows.map do |row|
      row_values = []

      row.css('td').each do |r|
        unless r.at_css('input')&.attr('src').present?
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

  def get_candidates(doc)
    table = doc.search('.table01')
  
    # column_names = table.css('thead tr th').map(&:text)
    # print column_names
    column_names = ["선거구명", 
                    "사진", 
                    "기호", 
                    "소속정당명", 
                    "성명(한자)", 
                    "성별", 
                    "생년월일(연령)", 
                    "주소", 
                    "직업", 
                    "학력", 
                    "경력", 
                    "재산신고액(천원)", 
                    "병역신고사항(본인)", 
                    "납부액", 
                    "최근5년간체납액", 
                    "현체납액", 
                    "전과기록유무(건수)", 
                    "입후보횟수"]

    rows = table.css('tbody tr')
    text_all_rows = rows.map do |row|
      row_values = []

      row.css('td').each do |r|
        unless r.at_css('input')&.attr('src').present?
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

  # 메인 화면 (시도->선거구->검색)
  def get_election_info(election_code, city_code, sgg_city_codes)
    headers = Hash.new
    headers['Content-Type'] = 'application/x-www-form-urlencoded'
  
    # file = File.open('/Users/hyungsungshim/Workspace/myproject/ssm/v2020/a.html', "r")
    # data = file.read
    # file.close
    # data
    url = 'http://info.nec.go.kr/electioninfo/electionInfo_report.xhtml'
    body = "electionId=#{ELECTION_ID}&requestURI=/WEB-INF/jsp/electioninfo/#{ELECTION_ID}/cp/cpri03.jsp&topMenuId=CP&statementId=CPRI03_#2&electionCode=#{election_code}&cityCode=#{city_code}&sggCityCode=#{sgg_city_codes}"
    # body = "electionId=#{ELECTION_ID}&requestURI=/WEB-INF/jsp/electioninfo/#{ELECTION_ID}/pc/pcri03_ex.jsp&topMenuId=PC&statementId=PCRI03_#2&electionCode=#{election_code}&cityCode=#{city_code}&sggCityCode=#{sgg_city_codes}"
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
