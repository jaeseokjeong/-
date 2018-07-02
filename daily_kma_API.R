## 기상 / 공휴일 API

getkma의 목적은 API를 활용하여  서울의 시간당 기상측정 데이터를 제공하는 것이다.


# select_period : 불러올 기간
# personal_key : 개인 API key

get_daily_kma <- function(start_date, end_date, personal_key){
  
  #기본 주소  
  url1<- "http://data.kma.go.kr/apiData/getData?type=json&dataCd=ASOS&dateCd=DAY&stnIds=108&schListCnt=10&pageIndex=1"
  
  #뽑아올 날짜
  url2 <- "&startDt="
  
  url3 <- "&endDt="
  
  
  #API Key
  url4 <- "&apiKey="
  mykey <- personal_key
  
  
  selected_period <- paste0(url1,
                            url2,
                            start_date,
                            url3,
                            end_date,
                            url4,
                            personal_key)
  
  
  result <- GET(selected_period)
  json <- content(result , as = "text")
  processed_json <- fromJSON(json)

  weather_informaiton <- processed_json$info[[4]] %>% 
    dplyr::select(TM,AVG_TA,AVG_WS,AVG_RHM)
  
  weather_informaiton
  
}

#한번에 1,000개 이하로만 추출가능
personal_key <- "자신의 API KEY"
start_date <- "20100101"
end_date <- "20100102"

example <- get_daily_kma(start_date, end_date, personal_key)
