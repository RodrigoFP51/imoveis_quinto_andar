library(tidyverse)
library(httr2)

# Headers -----------------------------------------------------------------

headers <- c(
  `accept` = "application/json",
  `accept-language` = "pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7",
  `content-type` = "application/json",
  `origin` = "https://www.quintoandar.com.br",
  `priority` = "u=1, i",
  `sec-ch-ua` = '"Not/A)Brand";v="8", "Chromium";v="126", "Google Chrome";v="126"',
  `sec-ch-ua-mobile` = "?0",
  `sec-ch-ua-platform` = '"Windows"',
  `sec-fetch-dest` = "empty",
  `sec-fetch-mode` = "cors",
  `sec-fetch-site` = "same-site",
  `user-agent` = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36"
)

# data <- '{"context":{"mapShowing":true,"listShowing":true,"userId":"xh-LafrPTCnbJksSnZUrPMRmcIEhRTNF4jJdn1pACe9oap_opAsw1Q","deviceId":"xh-LafrPTCnbJksSnZUrPMRmcIEhRTNF4jJdn1pACe9oap_opAsw1Q","numPhotos":12,"isSSR":false},"filters":{"businessContext":"SALE","blocklist":[],"selectedHouses":[],"location":{"coordinate":{"lat":-23.55052,"lng":-46.633309},"viewport":{"east":-46.56361448095702,"north":-23.468823057735495,"south":-23.6321662002967,"west":-46.70300351904296},"neighborhoods":[],"countryCode":"BR"},"priceRange":[],"specialConditions":[],"excludedSpecialConditions":[],"houseSpecs":{"area":{"range":{}},"houseTypes":["APARTMENT"],"amenities":[],"installations":[],"bathrooms":{"range":{}},"bedrooms":{"range":{}},"parkingSpace":{"range":{}}},"availability":"ANY","occupancy":"ANY","partnerIds":[],"categories":[]},"sorting":{"criteria":"RELEVANCE","order":"DESC"},"pagination":{"pageSize":12,"offset":0},"slug":"sao-paulo-sp-brasil","fields":["id","coverImage","rent","totalCost","salePrice","iptuPlusCondominium","area","imageList","imageCaptionList","address","regionName","city","visitStatus","activeSpecialConditions","type","forRent","forSale","isPrimaryMarket","bedrooms","parkingSpaces","listingTags","yield","yieldStrategy","neighbourhood","categories","bathrooms","isFurnished","installations"],"experiments":["ab_search_services_mono_pclick:1"]}'

# Request -----------------------------------------------------------------

## offset: parametro mandado no body json do POST REQUEST
offset <- c(0, seq(12, by = 11, length.out = 1000))
data <- 
  paste0(
    "{\"context\":{\"mapShowing\":true,\"listShowing\":true,\"userId\":\"xh-LafrPTCnbJksSnZUrPMRmcIEhRTNF4jJdn1pACe9oap_opAsw1Q\",\"deviceId\":\"xh-LafrPTCnbJksSnZUrPMRmcIEhRTNF4jJdn1pACe9oap_opAsw1Q\",\"numPhotos\":12,\"isSSR\":false},\"filters\":{\"businessContext\":\"SALE\",\"blocklist\":[],\"selectedHouses\":[],\"location\":{\"coordinate\":{\"lat\":-23.55052,\"lng\":-46.633309},\"viewport\":{\"east\":-46.56361448095702,\"north\":-23.468823057735495,\"south\":-23.6321662002967,\"west\":-46.70300351904296},\"neighborhoods\":[],\"countryCode\":\"BR\"},\"priceRange\":[],\"specialConditions\":[],\"excludedSpecialConditions\":[],\"houseSpecs\":{\"area\":{\"range\":{}},\"houseTypes\":[\"APARTMENT\"],\"amenities\":[],\"installations\":[],\"bathrooms\":{\"range\":{}},\"bedrooms\":{\"range\":{}},\"parkingSpace\":{\"range\":{}}},\"availability\":\"ANY\",\"occupancy\":\"ANY\",\"partnerIds\":[],\"categories\":[]},\"sorting\":{\"criteria\":\"RELEVANCE\",\"order\":\"DESC\"},\"pagination\":{\"pageSize\":12,\"offset\":", offset, "},\"slug\":\"sao-paulo-sp-brasil\",\"fields\":[\"id\",\"coverImage\",\"rent\",\"totalCost\",\"salePrice\",\"iptuPlusCondominium\",\"area\",\"imageList\",\"imageCaptionList\",\"address\",\"regionName\",\"city\",\"visitStatus\",\"activeSpecialConditions\",\"type\",\"forRent\",\"forSale\",\"isPrimaryMarket\",\"bedrooms\",\"parkingSpaces\",\"listingTags\",\"yield\",\"yieldStrategy\",\"neighbourhood\",\"categories\",\"bathrooms\",\"isFurnished\",\"installations\"],\"experiments\":[\"ab_search_services_mono_pclick:1\"]}"
  )

req_qa <-
  map(
    .x = data,
    .f = function(x){
      request("https://apigw.prod.quintoandar.com.br/cached/house-listing-search/v1/search/list") %>%
        req_headers(
          "accept" = "application/json",
          "accept-language" = "pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7",
          "content-type" = "application/json",
          "origin" = "https://www.quintoandar.com.br",
          "priority" = "u=1, i",
          "sec-ch-ua" = "\"Not/A)Brand\";v=\"8\", \"Chromium\";v=\"126\", \"Google Chrome\";v=\"126\"",
          "sec-ch-ua-mobile" = "?0",
          "sec-ch-ua-platform" = "\"Windows\"",
          "sec-fetch-dest" = "empty",
          "sec-fetch-mode" = "cors",
          "sec-fetch-site" = "same-site",
          "user-agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36"
        ) %>% 
        req_body_raw(x)
    }
  ) %>% 
  req_perform_sequential(progress = TRUE, on_error = "continue")

req_qa %>% 
  map_int(\(x) x$status_code)

all_dfs_raw <- 
  req_qa %>%
  resps_data(\(resp) {
    resp_body_json(resp, simplifyVector = TRUE) %>%
      pluck("hits", "hits", 3) %>%
      as_tibble()
    }
  )

all_dfs <- all_dfs_raw %>% 
  distinct(id, .keep_all = TRUE) %>% 
  select(-c(coverImage, city, type, 
            imageCaptionList, activeSpecialConditions, categories)) %>% 
  filter(totalCost < 1e5, 
         totalCost < salePrice,
         area < 2e3) %>%
  mutate(installations = map_chr(installations, str_flatten_comma)) %>% 
  drop_na()

write_rds(all_dfs, "imoveis.rds")



