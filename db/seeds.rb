#Thisfileshouldcontainalltherecordcreationneededtoseedthedatabasewithitsdefaultvalues.
#Thedatacanthenbeloadedwiththerailsdb:seedcommand(orcreatedalongsidethedatabasewithdb:setup).
#
#Examples:
#

# 비례정당 : # proportional_party
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

PoliticalParty.create(code:100 ,name1:'더불어민주당')
PoliticalParty.create(code:200 ,name1:'미래통합당')
PoliticalParty.create(code:2080,name1:'민생당')
PoliticalParty.create(code:5037,name1:'미래한국당')
PoliticalParty.create(code:5048,name1:'더불어시민당')
PoliticalParty.create(code:730 ,name1:'정의당')
PoliticalParty.create(code:5000,name1:'우리공화당')
PoliticalParty.create(code:5010,name1:'민중당')
PoliticalParty.create(code:3060,name1:'한국경제당')
PoliticalParty.create(code:5040,name1:'국민의당')
PoliticalParty.create(code:5044,name1:'친박신당')
PoliticalParty.create(code:5049,name1:'열린민주당')
PoliticalParty.create(code:1970,name1:'코리아')
PoliticalParty.create(code:3070,name1:'가자!평화인권당')
PoliticalParty.create(code:5039,name1:'가자환경당')
PoliticalParty.create(code:2010,name1:'공화당')
PoliticalParty.create(code:5031,name1:'국가혁명배당금당')
PoliticalParty.create(code:4080,name1:'국민새정당')
PoliticalParty.create(code:2070,name1:'국민참여신당')
PoliticalParty.create(code:2020,name1:'기독당')
PoliticalParty.create(code:3040,name1:'기독자유통일당')
PoliticalParty.create(code:5035,name1:'기본소득당')
PoliticalParty.create(code:5052,name1:'깨어있는시민연대당')
PoliticalParty.create(code:5051,name1:'남북통일당')
PoliticalParty.create(code:1988,name1:'노동당')
PoliticalParty.create(code:710 ,name1:'녹색당')
PoliticalParty.create(code:3010,name1:'대한당')
PoliticalParty.create(code:650 ,name1:'대한민국당')
PoliticalParty.create(code:4040,name1:'미래당')
PoliticalParty.create(code:5047,name1:'미래민주당')
PoliticalParty.create(code:1980,name1:'미래자영업당')
PoliticalParty.create(code:4010,name1:'민중민주당')
PoliticalParty.create(code:700 ,name1:'사이버모바일국민정책당')
PoliticalParty.create(code:4070,name1:'새누리당')
PoliticalParty.create(code:5042,name1:'시대전환')
PoliticalParty.create(code:5046,name1:'여성의당')
PoliticalParty.create(code:5053,name1:'우리당')
PoliticalParty.create(code:5043,name1:'자유당')
PoliticalParty.create(code:5030,name1:'새벽당')
PoliticalParty.create(code:5050,name1:'정치개혁연합')
PoliticalParty.create(code:5045,name1:'자영업당')
PoliticalParty.create(code:5033,name1:'직능자영업당')
PoliticalParty.create(code:5041,name1:'충청의미래당')
PoliticalParty.create(code:2000,name1:'친박연대')
PoliticalParty.create(code:2060,name1:'통일민주당')
PoliticalParty.create(code:4000,name1:'통합민주당')
PoliticalParty.create(code:2050,name1:'한국국민당')
PoliticalParty.create(code:3000,name1:'한국복지당')
PoliticalParty.create(code:1990,name1:'한나라당')
PoliticalParty.create(code:3050,name1:'한반도미래연합')
PoliticalParty.create(code:4060,name1:'홍익당')
exit!


Election.create(name1:'국회의원선거',code:2)
Election.create(name1:'구/시/군의장선거',code:4)
Election.create(name1:'시/도의회의원선거',code:5)
Election.create(name1:'구/시/군의회의원선거',code:6)

election=Election.find_by(code:2)

election.cities.create(name1:'서울',code:1100)
election.cities.create(name1:'부산',code:2600)
election.cities.create(name1:'대구',code:2700)
election.cities.create(name1:'인천',code:2800)
election.cities.create(name1:'광주',code:2900)
election.cities.create(name1:'대전',code:3000)
election.cities.create(name1:'울산',code:3100)
election.cities.create(name1:'세종',code:5100)
election.cities.create(name1:'경기',code:4100)
election.cities.create(name1:'강원',code:4200)
election.cities.create(name1:'충청북',code:4300)
election.cities.create(name1:'충청남',code:4400)
election.cities.create(name1:'전라북',code:4500)
election.cities.create(name1:'전라남',code:4600)
election.cities.create(name1:'경상북',code:4700)
election.cities.create(name1:'경상남',code:4800)
election.cities.create(name1:'제주',code:4900)


#서울
city=City.find_by(code:1100)
city.voting_districts.create(name1:'종로구',code:2110101)
city.voting_districts.create(name1:'중구성동구갑',code:2110402)
city.voting_districts.create(name1:'중구성동구을',code:2110201)
city.voting_districts.create(name1:'용산구',code:2110301)
city.voting_districts.create(name1:'광진구갑',code:2110501)
city.voting_districts.create(name1:'광진구을',code:2110502)
city.voting_districts.create(name1:'동대문구갑',code:2110601)
city.voting_districts.create(name1:'동대문구을',code:2110602)
city.voting_districts.create(name1:'중랑구갑',code:2110701)
city.voting_districts.create(name1:'중랑구을',code:2110702)
city.voting_districts.create(name1:'성북구갑',code:2110801)
city.voting_districts.create(name1:'성북구을',code:2110802)
city.voting_districts.create(name1:'강북구갑',code:2110901)
city.voting_districts.create(name1:'강북구을',code:2110902)
city.voting_districts.create(name1:'도봉구갑',code:2111001)
city.voting_districts.create(name1:'도봉구을',code:2111002)
city.voting_districts.create(name1:'노원구갑',code:2111101)
city.voting_districts.create(name1:'노원구을',code:2111102)
city.voting_districts.create(name1:'노원구병',code:2111103)
city.voting_districts.create(name1:'은평구갑',code:2111201)
city.voting_districts.create(name1:'은평구을',code:2111202)
city.voting_districts.create(name1:'서대문구갑',code:2111301)
city.voting_districts.create(name1:'서대문구을',code:2111302)
city.voting_districts.create(name1:'마포구갑',code:2111401)
city.voting_districts.create(name1:'마포구을',code:2111402)
city.voting_districts.create(name1:'양천구갑',code:2111501)
city.voting_districts.create(name1:'양천구을',code:2111502)
city.voting_districts.create(name1:'강서구갑',code:2111601)
city.voting_districts.create(name1:'강서구을',code:2111602)
city.voting_districts.create(name1:'강서구병',code:2111603)
city.voting_districts.create(name1:'구로구갑',code:2111701)
city.voting_districts.create(name1:'구로구을',code:2111702)
city.voting_districts.create(name1:'금천구',code:2111801)
city.voting_districts.create(name1:'영등포구갑',code:2111901)
city.voting_districts.create(name1:'영등포구을',code:2111902)
city.voting_districts.create(name1:'동작구갑',code:2112001)
city.voting_districts.create(name1:'동작구을',code:2112002)
city.voting_districts.create(name1:'관악구갑',code:2112101)
city.voting_districts.create(name1:'관악구을',code:2112102)
city.voting_districts.create(name1:'서초구갑',code:2112201)
city.voting_districts.create(name1:'서초구을',code:2112202)
city.voting_districts.create(name1:'강남구갑',code:2112301)
city.voting_districts.create(name1:'강남구을',code:2112302)
city.voting_districts.create(name1:'강남구병',code:2112303)
city.voting_districts.create(name1:'송파구갑',code:2112401)
city.voting_districts.create(name1:'송파구을',code:2112402)
city.voting_districts.create(name1:'송파구병',code:2112403)
city.voting_districts.create(name1:'강동구갑',code:2112501)
city.voting_districts.create(name1:'강동구을',code:2112502)


#부산
city=City.find_by(code:2600)
city.voting_districts.create(name1:'중구영도구',code:2260401)
city.voting_districts.create(name1:'서구동구',code:2260201)
city.voting_districts.create(name1:'부산진구갑',code:2260501)
city.voting_districts.create(name1:'부산진구을',code:2260502)
city.voting_districts.create(name1:'동래구',code:2260601)
city.voting_districts.create(name1:'남구갑',code:2260701)
city.voting_districts.create(name1:'남구을',code:2260702)
city.voting_districts.create(name1:'북구강서구갑',code:2260801)
city.voting_districts.create(name1:'북구강서구을',code:2261301)
city.voting_districts.create(name1:'해운대구갑',code:2260902)
city.voting_districts.create(name1:'해운대구을',code:2260903)
city.voting_districts.create(name1:'사하구갑',code:2261101)
city.voting_districts.create(name1:'사하구을',code:2261102)
city.voting_districts.create(name1:'금정구',code:2261201)
city.voting_districts.create(name1:'연제구',code:2261401)
city.voting_districts.create(name1:'수영구',code:2261501)
city.voting_districts.create(name1:'사상구',code:2261601)
city.voting_districts.create(name1:'기장군',code:2261002)

#대구
city=City.find_by(code:2700)
city.voting_districts.create(name1:'중구남구',code:2270101)
city.voting_districts.create(name1:'동구갑',code:2270201)
city.voting_districts.create(name1:'동구을',code:2270202)
city.voting_districts.create(name1:'서구',code:2270301)
city.voting_districts.create(name1:'북구갑',code:2270501)
city.voting_districts.create(name1:'북구을',code:2270502)
city.voting_districts.create(name1:'수성구갑',code:2270601)
city.voting_districts.create(name1:'수성구을',code:2270602)
city.voting_districts.create(name1:'달서구갑',code:2270701)
city.voting_districts.create(name1:'달서구을',code:2270702)
city.voting_districts.create(name1:'달서병병',code:2270703)
city.voting_districts.create(name1:'달성군',code:2270801)

#인천
city=City.find_by(code:2800)
city.voting_districts.create(name1:'중구동구강화군옹진군',code:2280101)
city.voting_districts.create(name1:'미추홀구갑',code:2280301)
city.voting_districts.create(name1:'미추홀구을',code:2280302)
city.voting_districts.create(name1:'연수구갑',code:2280402)
city.voting_districts.create(name1:'연수구을',code:2280403)
city.voting_districts.create(name1:'남동구갑',code:2280501)
city.voting_districts.create(name1:'남동구을',code:2280502)
city.voting_districts.create(name1:'부평구갑',code:2280601)
city.voting_districts.create(name1:'부평구을',code:2280602)
city.voting_districts.create(name1:'계양구갑',code:2280701)
city.voting_districts.create(name1:'계양구을',code:2280702)
city.voting_districts.create(name1:'서구갑',code:2280802)
city.voting_districts.create(name1:'서구을',code:2280803)

#광주
city=City.find_by(code:2900)
city.voting_districts.create(name1:'동구남구갑',code:2290302)
city.voting_districts.create(name1:'동구남구을',code:2290101)
city.voting_districts.create(name1:'서구갑',code:2290201)
city.voting_districts.create(name1:'서구을',code:2290202)
city.voting_districts.create(name1:'북구갑',code:2290401)
city.voting_districts.create(name1:'북구을',code:2290402)
city.voting_districts.create(name1:'광산구갑',code:2290501)
city.voting_districts.create(name1:'광산구을',code:2290502)

#대전
city=City.find_by(code:3000)
city.voting_districts.create(name1:'동구',code:2300101)
city.voting_districts.create(name1:'중구',code:2300201)
city.voting_districts.create(name1:'서구갑',code:2300301)
city.voting_districts.create(name1:'서구을',code:2300302)
city.voting_districts.create(name1:'유성구갑',code:2300402)
city.voting_districts.create(name1:'유성구을',code:2300403)
city.voting_districts.create(name1:'대덕구',code:2300501)

#울산
city=City.find_by(code:3100)
city.voting_districts.create(name1:'중구',code:2310101)
city.voting_districts.create(name1:'남구갑',code:2310201)
city.voting_districts.create(name1:'남구을',code:2310202)
city.voting_districts.create(name1:'동구',code:2310301)
city.voting_districts.create(name1:'북구',code:2310401)
city.voting_districts.create(name1:'울주군',code:2310501)

#세종
city=City.find_by(code:5100)
city.voting_districts.create(name1:'세종특별자치시',code:2510101)

#경기
city=City.find_by(code:4100)
city.voting_districts.create(name1:'수원시갑',code:2410101)
city.voting_districts.create(name1:'수원시을',code:2410201)
city.voting_districts.create(name1:'수원시병',code:2410301)
city.voting_districts.create(name1:'수원시정',code:2410401)
city.voting_districts.create(name1:'수원시무',code:2410202)
city.voting_districts.create(name1:'성남시수정구',code:2410501)
city.voting_districts.create(name1:'성남시중원구',code:2410601)
city.voting_districts.create(name1:'성남시분당구갑',code:2410701)
city.voting_districts.create(name1:'성남시분당구을',code:2410702)
city.voting_districts.create(name1:'의정부시갑',code:2410801)
city.voting_districts.create(name1:'의정부시을',code:2410802)
city.voting_districts.create(name1:'안양시만안구',code:2410901)
city.voting_districts.create(name1:'안양시동안구갑',code:2411001)
city.voting_districts.create(name1:'안양시동안구을',code:2411002)
city.voting_districts.create(name1:'부천시원미구갑',code:2411101)
city.voting_districts.create(name1:'부천시원미구을',code:2411102)
city.voting_districts.create(name1:'부천시소사구',code:2411201)
city.voting_districts.create(name1:'부천시오정구',code:2411301)
city.voting_districts.create(name1:'광명시갑',code:2411401)
city.voting_districts.create(name1:'광명시을',code:2411402)
city.voting_districts.create(name1:'평택시갑',code:2411501)
city.voting_districts.create(name1:'평택시을',code:2411502)
city.voting_districts.create(name1:'동두천시연천군',code:2411701)
city.voting_districts.create(name1:'안산시상록구갑',code:2411801)
city.voting_districts.create(name1:'안산시상록구을',code:2411802)
city.voting_districts.create(name1:'안산시단원구갑',code:2411901)
city.voting_districts.create(name1:'안산시단원구을',code:2411902)
city.voting_districts.create(name1:'고양시갑',code:2412001)
city.voting_districts.create(name1:'고양시을',code:2412002)
city.voting_districts.create(name1:'고양시병',code:2412101)
city.voting_districts.create(name1:'고양시정',code:2412201)
city.voting_districts.create(name1:'의왕시과천시',code:2412301)
city.voting_districts.create(name1:'구리시',code:2412501)
city.voting_districts.create(name1:'남양주시갑',code:2412601)
city.voting_districts.create(name1:'남양주시을',code:2412602)
city.voting_districts.create(name1:'남양주시병',code:2412603)
city.voting_districts.create(name1:'오산시',code:2412701)
city.voting_districts.create(name1:'시흥시갑',code:2412901)
city.voting_districts.create(name1:'시흥시을',code:2412902)
city.voting_districts.create(name1:'군포시갑',code:2413002)
city.voting_districts.create(name1:'군포시을',code:2413003)
city.voting_districts.create(name1:'하남시',code:2413101)
city.voting_districts.create(name1:'용인시갑',code:2413501)
city.voting_districts.create(name1:'용인시을',code:2413701)
city.voting_districts.create(name1:'용인시병',code:2413602)
city.voting_districts.create(name1:'용인시정',code:2413702)
city.voting_districts.create(name1:'파주시갑',code:2413202)
city.voting_districts.create(name1:'파주시을',code:2413203)
city.voting_districts.create(name1:'이천시',code:2413401)
city.voting_districts.create(name1:'안성시',code:2413801)
city.voting_districts.create(name1:'김포시갑',code:2413902)
city.voting_districts.create(name1:'김포시을',code:2413903)
city.voting_districts.create(name1:'화성시갑',code:2412801)
city.voting_districts.create(name1:'화성시을',code:2412802)
city.voting_districts.create(name1:'화성시병',code:2412803)
city.voting_districts.create(name1:'광주시갑',code:2414002)
city.voting_districts.create(name1:'광주시을',code:2414003)
city.voting_districts.create(name1:'양주시',code:2411602)
city.voting_districts.create(name1:'포천시가평군',code:2414102)
city.voting_districts.create(name1:'여주시양평군',code:2413301)

#강원
city=City.find_by(code:4200)
city.voting_districts.create(name1:'춘천시',code:2420101)
city.voting_districts.create(name1:'원주시갑',code:2420202)
city.voting_districts.create(name1:'원주시을',code:2420203)
city.voting_districts.create(name1:'강릉시',code:2420301)
city.voting_districts.create(name1:'동해시삼척시',code:2420401)
city.voting_districts.create(name1:'태백시횡성군영월군평창군정선군',code:2421401)
city.voting_districts.create(name1:'속초시고성군양양군',code:2420801)
city.voting_districts.create(name1:'홍천군철원군화천군양구군인제군',code:2421601)

#충청북
city=City.find_by(code:4300)
city.voting_districts.create(name1:'청주시상당구',code:2430101)
city.voting_districts.create(name1:'청주시서원구',code:2430201)
city.voting_districts.create(name1:'청주시흥덕구',code:2430202)
city.voting_districts.create(name1:'청주시청원구',code:2430601)
city.voting_districts.create(name1:'충주시',code:2430301)
city.voting_districts.create(name1:'제천시단양군',code:2430401)
city.voting_districts.create(name1:'보은군옥천군영동군괴산군',code:2430701)
city.voting_districts.create(name1:'증평군진천군음성군',code:2431002)

#충청남
city=City.find_by(code:4400)
city.voting_districts.create(name1:'천안시갑',code:2440101)
city.voting_districts.create(name1:'천안시을',code:2440102)
city.voting_districts.create(name1:'천안시병',code:2440103)
city.voting_districts.create(name1:'공주시부여군청양군',code:2440202)
city.voting_districts.create(name1:'보령시서천군',code:2440301)
city.voting_districts.create(name1:'아산시갑',code:2440402)
city.voting_districts.create(name1:'아산시을',code:2440403)
city.voting_districts.create(name1:'서산시태안군',code:2440501)
city.voting_districts.create(name1:'논산시계룡시금산군',code:2440901)
city.voting_districts.create(name1:'당진시',code:2441601)
city.voting_districts.create(name1:'홍성군예산군',code:2441301)

#전라북
city=City.find_by(code:4500)
city.voting_districts.create(name1:'전주시갑',code:2450101)
city.voting_districts.create(name1:'전주시을',code:2450102)
city.voting_districts.create(name1:'전주시병',code:2450201)
city.voting_districts.create(name1:'군산시',code:2450301)
city.voting_districts.create(name1:'익산시갑',code:2450501)
city.voting_districts.create(name1:'익산시을',code:2450502)
city.voting_districts.create(name1:'정읍시고창군',code:2450701)
city.voting_districts.create(name1:'남원시임실군순창군',code:2450801)
city.voting_districts.create(name1:'김제시부안군',code:2450902)
city.voting_districts.create(name1:'완주군진안군무주군장수군',code:2451001)

#전라남
city=City.find_by(code:4600)
city.voting_districts.create(name1:'목포시',code:2460101)
city.voting_districts.create(name1:'여수시갑',code:2460201)
city.voting_districts.create(name1:'여수시을',code:2460202)
city.voting_districts.create(name1:'순천시',code:2460403)
city.voting_districts.create(name1:'나주시화순군',code:2460601)
city.voting_districts.create(name1:'광양시곡성군구례군',code:2460702)
city.voting_districts.create(name1:'담양군함평군영광군장성군',code:2462202)
city.voting_districts.create(name1:'고흥군보성군장흥군강진군',code:2461201)
city.voting_districts.create(name1:'해남군완도군진도군',code:2461801)
city.voting_districts.create(name1:'영암군무안군신안군',code:2462101)

#경상북
city=City.find_by(code:4700)
city.voting_districts.create(name1:'포항시북구',code:2470101)
city.voting_districts.create(name1:'포항시남구울릉군',code:2470201)
city.voting_districts.create(name1:'경주시',code:2470401)
city.voting_districts.create(name1:'김천시',code:2470501)
city.voting_districts.create(name1:'안동시',code:2470601)
city.voting_districts.create(name1:'구미시갑',code:2470701)
city.voting_districts.create(name1:'구미시을',code:2470702)
city.voting_districts.create(name1:'영주시문경시예천군',code:2470801)
city.voting_districts.create(name1:'영천시청도군',code:2470901)
city.voting_districts.create(name1:'상주시군위군의성군청송군',code:2471001)
city.voting_districts.create(name1:'경산시',code:2471302)
city.voting_districts.create(name1:'영양군영덕군봉화군울진군',code:2472201)
city.voting_districts.create(name1:'고령군성주군칠곡군',code:2471701)

#경상남
city=City.find_by(code:4800)
city.voting_districts.create(name1:'창원시의창구',code:2480101)
city.voting_districts.create(name1:'창원시성산구',code:2480102)
city.voting_districts.create(name1:'창원시마산합포구',code:2480201)
city.voting_districts.create(name1:'창원시마산회원구',code:2480202)
city.voting_districts.create(name1:'창원시진해구',code:2480401)
city.voting_districts.create(name1:'진주시갑',code:2480301)
city.voting_districts.create(name1:'진주시을',code:2480302)
city.voting_districts.create(name1:'통영시고성군',code:2480501)
city.voting_districts.create(name1:'사천시남해군하동군',code:2480702)
city.voting_districts.create(name1:'김해시갑',code:2480801)
city.voting_districts.create(name1:'김해시을',code:2480802)
city.voting_districts.create(name1:'밀양시의령군함안군창녕군',code:2480901)
city.voting_districts.create(name1:'거제시',code:2481001)
city.voting_districts.create(name1:'양산시갑',code:2481402)
city.voting_districts.create(name1:'양산시을',code:2481403)
city.voting_districts.create(name1:'산청군함양군거창군합천군',code:2481901)

#제주
city=City.find_by(code:4900)
city.voting_districts.create(name1:'제주시갑',code:2490101)
city.voting_districts.create(name1:'제주시을',code:2490102)
city.voting_districts.create(name1:'서귀포시',code:2490201)
