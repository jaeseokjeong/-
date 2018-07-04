#need_package
library(httr)
library(curl)
library(jsonlite)
library(dplyr)


# selected_year : 추출할 년도
# personal_key : 개인 API key

get_holiday <- function(selected_year, personal_key) {
  
  #기본 주소
  url1<- "http://apis.data.go.kr/B090041/openapi/service/SpcdeInfoService/getRestDeInfo?"
  
  #뽑아올 year, month
  url2 <- "&solYear="
  url3 <- "&solMonth="
  
  #API Key
  url4 <- "serviceKey="
  mykey <- personal_key
  
  holiday_list <- list()
  extract_month <- c("01","02","03","04","05","06","07","08","09","10","11","12")
  
  for(i in 1:length(extract_month)){
    
    #URL 결합
    requestUrl <- paste0(url1,
                         url4, mykey,
                         url2, selected_year, 
                         url3, extract_month[i])
    
    
    #불러오기
    result <- GET(requestUrl)
    
    json <- content(result , as = "text")
    processed_json <- fromJSON(json)
    
    
    if(processed_json$response$body$totalCount > 0) {
      
      holiday_day <- processed_json$response$body$items$item
      
      holiday_list[[i]] <- data.table(dateName = holiday_day[[2]],
                                      isHoliday = holiday_day[[3]],
                                      date = holiday_day[[4]])    
    } else {
      
      not_include_holiday <- processed_json$response$body$totalCount
    }
  }
  
  holiday_table <- rbindlist(holiday_list)
  
}

# example
# 2016년 공휴일 데이터 가져오기 
personal_key_1 <- "자신의 API key"
holiday_table <- get_holiday("2016", personal_key_1)
