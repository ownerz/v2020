# frozen_string_literal: true

# require 'singleton'
require 'faraday'
require 'nokogiri'
require 'open-uri'

class CrawleringService
  # include Singleton

  # CITY_CODES = {
  #   :seoul => '1100',
  #   :busan => '2600',
  #   :daegu => '2700',
  #   :incheon => '2800',
  #   :gwangju => '2900',
  #   :daejeon => '3000',
  #   :ulsan => '3100',
  #   :sejong => '5100',
  #   :gyengggi => '4100',
  #   :gangwon => '4200',
  #   :chungcheongbuk => '4300',
  #   :chungcheongnam => '4400',
  #   :jeollabuk => '4500',
  #   :jeollanam => '4600',
  #   :gyeongsangbuk => '4700',
  #   :gyeongsangnam => '4800',
  #   :jeju => '4900',
  # }

  # 선거 code
  # 국회의원 선거 : 2
  # 구/시/군 의장선거 : 4
  # 시/도 의회 의원선거 : 5
  # 구/시/군 의회 의원선거 : 6

  CITY_CODES = [
    # 서울
    {'city_code': '1100',
     'sgg_city_codes': [
      '2110101',  #종로구
      '2110402',  #중구성동구갑
      '2110201',  #중구성동구을
      '2110301',  #용산구
      '2110501',  #광진구갑
      '2110502',  #광진구을
      '2110601',  #동대문구갑
      '2110602',  #동대문구을
      '2110701',  #중랑구갑
      '2110702',  #중랑구을
      '2110801',  #성북구갑
      '2110802',  #성북구을
      '2110901',  #강북구갑
      '2110902',  #강북구을
      '2111001',  #도봉구갑
      '2111002',  #도봉구을
      '2111101',  #노원구갑
      '2111102',  #노원구을
      '2111103',  #노원구병
      '2111201',  #은평구갑
      '2111202',  #은평구을
      '2111301',  #서대문구갑
      '2111302',  #서대문구을
      '2111401',  #마포구갑
      '2111402',  #마포구을
      '2111501',  #양천구갑
      '2111502',  #양천구을
      '2111601',  #강서구갑
      '2111602',  #강서구을
      '2111603',  #강서구병
      '2111701',  #구로구갑
      '2111702',  #구로구을
      '2111801',  #금천구
      '2111901',  #영등포구갑
      '2111902',  #영등포구을
      '2112001',  #동작구갑
      '2112002',  #동작구을
      '2112101',  #관악구갑
      '2112102',  #관악구을
      '2112201',  #서초구갑
      '2112202',  #서초구을
      '2112301',  #강남구갑
      '2112302',  #강남구을
      '2112303',  #강남구병
      '2112401',  #송파구갑
      '2112402',  #송파구을
      '2112403',  #송파구병
      '2112501',  #강동구갑
      '2112502',  #강동구을
    ]},
    {
      'city_code': '2600',
      'sgg_city_codes': [
      # 부산
      '2260401',  #중구영도구
      '2260201',  #서구동구
      '2260501',  #부산진구갑
      '2260502',  #부산진구을
      '2260601',  #동래구
      '2260701',  #남구갑
      '2260702',  #남구을
      '2260801',  #북구강서구갑
      '2261301',  #북구강서구을
      '2260902',  #해운대구갑
      '2260903',  #해운대구을
      '2261101',  #사하구갑
      '2261102',  #사하구을
      '2261201',  #금정구
      '2261401',  #연제구
      '2261501',  #수영구
      '2261601',  #사상구
      '2261002',  #기장군
    ]},
    {
      'city_code': '2700',
      'sgg_city_codes': [
      # 대구
      '2270101',  #중구남구
      '2270201',  #동구갑
      '2270202',  #동구을
      '2270301',  #서구
      '2270501',  #북구갑
      '2270502',  #북구을
      '2270601',  #수성구갑
      '2270602',  #수성구을
      '2270701',  #달서구갑
      '2270702',  #달서구을
      '2270703',  #달서구병
      '2270801',  #달성군
    ]},
    {
      'city_code': '2800',
      'sgg_city_codes': [
      # 인천
      '2280101',  #중구동구강화군옹진군
      '2280301',  #미추홀구갑
      '2280302',  #미추홀구을
      '2280402',  #연수구갑
      '2280403',  #연수구을
      '2280501',  #남동구갑
      '2280502',  #남동구을
      '2280601',  #부평구갑
      '2280602',  #부평구을
      '2280701',  #계양구갑
      '2280702',  #계양구을
      '2280802',  #서구갑
      '2280803',  #서구을
    ]},
    {
      'city_code': '2900',
      'sgg_city_codes': [
      # 광주
      '2290302',  #동구남구갑
      '2290101',  #동구남구을
      '2290201',  #서구갑
      '2290202',  #서구을
      '2290401',  #북구갑
      '2290402',  #북구을
      '2290501',  #광산구갑
      '2290502',  #광산구을
    ]},
    {
      'city_code': '3000',
      'sgg_city_codes': [
      # 대전
      '2300101',  #동구
      '2300201',  #중구
      '2300301',  #서구갑
      '2300302',  #서구을
      '2300402',  #유성구갑
      '2300403',  #유성구을
      '2300501',  #대덕구
    ]},
    {
      'city_code': '3100',
      'sgg_city_codes': [
      # 울산
      '2310101',  #중구
      '2310201',  #남구갑
      '2310202',  #남구을
      '2310301',  #동구
      '2310401',  #북구
      '2310501',  #울주군
    ]},
    {
      'city_code': '5100',
      'sgg_city_codes': [
  # 세종
      '2510101',  #세종특별자치시
    ]},
    {
      'city_code': '4100',
      'sgg_city_codes': [
      # 경기
      '2410101',  #수원시갑
      '2410201',  #수원시을
      '2410301',  #수원시병
      '2410401',  #수원시정
      '2410202',  #수원시무
      '2410501',  #성남시수정구
      '2410601',  #성남시중원구
      '2410701',  #성남시분당구갑
      '2410702',  #성남시분당구을
      '2410801',  #의정부시갑
      '2410802',  #의정부시을
      '2410901',  #안양시만안구
      '2411001',  #안양시동안구갑
      '2411002',  #안양시동안구을
      '2411101',  #부천시원미구갑
      '2411102',  #부천시원미구을
      '2411201',  #부천시소사구
      '2411301',  #부천시오정구
      '2411401',  #광명시갑
      '2411402',  #광명시을
      '2411501',  #평택시갑
      '2411502',  #평택시을
      '2411701',  #동두천시연천군
      '2411801',  #안산시상록구갑
      '2411802',  #안산시상록구을
      '2411901',  #안산시단원구갑
      '2411902',  #안산시단원구을
      '2412001',  #고양시갑
      '2412002',  #고양시을
      '2412101',  #고양시병
      '2412201',  #고양시정
      '2412301',  #의왕시과천시
      '2412501',  #구리시
      '2412601',  #남양주시갑
      '2412602',  #남양주시을
      '2412603',  #남양주시병
      '2412701',  #오산시
      '2412901',  #시흥시갑
      '2412902',  #시흥시을
      '2413002',  #군포시갑
      '2413003',  #군포시을
      '2413101',  #하남시
      '2413501',  #용인시갑
      '2413701',  #용인시을
      '2413602',  #용인시병
      '2413702',  #용인시정
      '2413202',  #파주시갑
      '2413203',  #파주시을
      '2413401',  #이천시
      '2413801',  #안성시
      '2413902',  #김포시갑
      '2413903',  #김포시을
      '2412801',  #화성시갑
      '2412802',  #화성시을
      '2412803',  #화성시병
      '2414002',  #광주시갑
      '2414003',  #광주시을
      '2411602',  #양주시
      '2414102',  #포천시가평군
      '2413301',  #여주시양평군
    ]},
    {
      'city_code': '4200',
      'sgg_city_codes': [
      # 강원
      '2420101',  #춘천시
      '2420202',  #원주시갑
      '2420203',  #원주시을
      '2420301',  #강릉시
      '2420401',  #동해시삼척시
      '2421401',  #태백시횡성군영월군평창군정선군
      '2420801',  #속초시고성군양양군
      '2421601',  #홍천군철원군화천군양구군인제군
    ]},
    {
      'city_code': '4300',
      'sgg_city_codes': [
      # 충청북
      '2430101',  #청주시상당구
      '2430201',  #청주시서원구
      '2430202',  #청주시흥덕구
      '2430601',  #청주시청원구
      '2430301',  #충주시
      '2430401',  #제천시단양군
      '2430701',  #보은군옥천군영동군괴산군
      '2431002',  #증평군진천군음성군
    ]},
    {
      'city_code': '4400',
      'sgg_city_codes': [
      # 충청남
      '2440101',  #천안시갑
      '2440102',  #천안시을
      '2440103',  #천안시병
      '2440202',  #공주시부여군청양군
      '2440301',  #보령시서천군
      '2440402',  #아산시갑
      '2440403',  #아산시을
      '2440501',  #서산시태안군
      '2440901',  #논산시계룡시금산군
      '2441601',  #당진시
      '2441301',  #홍성군예산군
    ]},
    {
      'city_code': '4500',
      'sgg_city_codes': [
      # 전라북
      '2450101',  #전주시갑
      '2450102',  #전주시을
      '2450201',  #전주시병
      '2450301',  #군산시
      '2450501',  #익산시갑
      '2450502',  #익산시을
      '2450701',  #정읍시고창군
      '2450801',  #남원시임실군순창군
      '2450902',  #김제시부안군
      '2451001',  #완주군진안군무주군장수군
    ]},
    {
      'city_code': '4600',
      'sgg_city_codes': [
      # 전라남
      '2460101',  #목포시
      '2460201',  #여수시갑
      '2460202',  #여수시을
      '2460403',  #순천시
      '2460601',  #나주시화순군
      '2460702',  #광양시곡성군구례군
      '2462202',  #담양군함평군영광군장성군
      '2461201',  #고흥군보성군장흥군강진군
      '2461801',  #해남군완도군진도군
      '2462101',  #영암군무안군신안군
    ]},
    {
      'city_code': '4700',
      'sgg_city_codes': [
      # 경상북
      '2470101',  #포항시북구
      '2470201',  #포항시남구울릉군
      '2470401',  #경주시
      '2470501',  #김천시
      '2470601',  #안동시
      '2470701',  #구미시갑
      '2470702',  #구미시을
      '2470801',  #영주시문경시예천군
      '2470901',  #영천시청도군
      '2471001',  #상주시군위군의성군청송군
      '2471302',  #경산시
      '2472201',  #영양군영덕군봉화군울진군
      '2471701',  #고령군성주군칠곡군
    ]},
    {
      'city_code': '4800',
      'sgg_city_codes': [
      # 경상남
      '2480101',  #창원시의창구
      '2480102',  #창원시성산구
      '2480201',  #창원시마산합포구
      '2480202',  #창원시마산회원구
      '2480401',  #창원시진해구
      '2480301',  #진주시갑
      '2480302',  #진주시을
      '2480501',  #통영시고성군
      '2480702',  #사천시남해군하동군
      '2480801',  #김해시갑
      '2480802',  #김해시을
      '2480901',  #밀양시의령군함안군창녕군
      '2481001',  #거제시
      '2481402',  #양산시갑
      '2481403',  #양산시을
      '2481901',  #산청군함양군거창군합천군
    ]},
    {
      'city_code': '4900',
      'sgg_city_codes': [
      # 제주
      '2490101',  #제주시갑
      '2490102',  #제주시을
      '2490201',  #서귀포시
    ]}
  ]


  def initialize()
    @logger = Logger.new(STDOUT)
  end

  def crawlering()
    doc = Nokogiri::HTML(get_http_page(2, 1, 2))
    candidates = get_candidates(doc)

    # p candidates
    candidates.each do |candidate|
      c = Candidate.find_or_initialize_by(electoral_district: candidate.dig('선거구명'), 
                                      party: candidate.dig('소속정당명'),
                                      name: candidate.dig('성명(한자)'),
                                      birth_date: candidate.dig('생년월일(연령)')
                                      )
      if c.new_record?
        c.photo = candidate.dig('사진')
        c.sex = candidate.dig('성별')
        c.address = candidate.dig('주소')
        c.job = candidate.dig('직업')
        c.education = candidate.dig('학력')
        c.career = candidate.dig('경력')
        c.criminal_record = candidate.dig('전과기록유무(건수)')
        c.reg_date = candidate.dig('등록일자')
      end
      c.save!
    end


    exit

    CITY_CODES.each do |city_code|
      city_code[:sgg_city_codes].each do |sgg_city_code|
        p "#{city_code[:city_code]} - #{sgg_city_code}"

        #  id                 :bigint           not null, primary key
#  electoral_district :string(255)      default("")
#  party              :string(255)      default("")
#  photo              :string(255)      default("")
#  name               :string(255)      default("")
#  sex                :string(255)      default("")
#  birth_date         :string(255)      default("")
#  address            :string(255)      default("")
#  job                :string(255)      default("")
#  education          :string(255)      default("")
#  career             :string(255)      default("")
#  criminal_record    :string(255)      default("")
#  reg_date           :string(255)      default("")
#  wiki_page          :string(255)      default("")
#  deleted_at         :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#


        # doc = Nokogiri::HTML(get_http_page(2, city_code[:city_code], sgg_city_code))
        # candidates = get_candidates(doc)
      end
    end

  end

  private

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

  def get_http_page(election_code, city_code, sgg_city_codes)
    headers = Hash.new
    headers['Content-Type'] = 'application/x-www-form-urlencoded'
  
    file = File.open('/Users/hyungsungshim/Workspace/myproject/ssm/v2020/a.html', "r")
    data = file.read
    file.close
    data
  
    # url = 'http://info.nec.go.kr/electioninfo/electionInfo_report.xhtml'
    # body = "electionId=0020200415&requestURI=/WEB-INF/jsp/electioninfo/0020200415/pc/pcri03_ex.jsp&topMenuId=PC&statementId=PCRI03_#2&electionCode=#{election_code}&cityCode=#{city_code}&sggCityCode=#{sgg_city_codes}"
    # res = http_post_request url, headers, body
    # res.body
  end

  def http_get_request (url, headers = {})
    con = Faraday.new
    begin
      res = con.get do |req|
        req.url url
        req.headers = headers
      end
    rescue Faraday::Error => e
      raise ApiExceptions::CustomException.new(e)
    end
    res
  end

  def http_post_request(url, headers = {}, body)
    con = Faraday.new
    begin
      res = con.post do |req|
        req.url url
        req.headers = headers
        req.options.timeout = 2
        req.body = body
      end
    rescue Faraday::Error => e
      raise ApiExceptions::OauthCallbackError
    end
    res
  end
end
