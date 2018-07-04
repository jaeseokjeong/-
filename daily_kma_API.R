## 기상 / 공휴일 API

#need_package
library(httr)
library(curl)
library(jsonlite)
library(dplyr)

# start_date : 불러올 시작일
# end_date : 불러올 종료일
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
  
  #주소결합
  selected_period <- paste0(url1,
                            url2,
                            start_date,
                            url3,
                            end_date,
                            url4,
                            personal_key)
  
  #R로 불러오기
  result <- GET(selected_period)
  json <- content(result , as = "text")
  processed_json <- fromJSON(json)
  
  #불러올 변수명 선택(필요하면 word에 있는 다른변수 넣어도 됨)
  weather_informaiton <- processed_json$info[[4]] %>% 
    dplyr::select(TM,AVG_TA,AVG_WS,AVG_RHM)
  
  weather_informaiton
  
}

#한번에 1,000개 이하로만 추출가능

# example_1
personal_key <- "자신의 API KEY"
start_date <- "20100101"
end_date <- "20100102"

example <- get_daily_kma(start_date, end_date, personal_key)

#example_2
#1 & 2월 뽑아오기
weather_information <- list()

weather_informaiton[1] <- get_daily_kma("20160101", "20160131", personal_key)
weather_informaiton[2] <- get_daily_kma("20160201", "20160228", personal_key)

weather_info <- data.table:: rbindlist(weather_information)


