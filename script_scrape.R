library(tidyverse)
library(httr2)

# Headers -----------------------------------------------------------------

# curl 'https://apigw.prod.quintoandar.com.br/cached/house-listing-search/v1/search/list' \
# -H 'accept: application/json' \
# -H 'accept-language: pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7' \
# -H 'content-type: application/json' \
# -H 'cookie: ab.storage.deviceId.cf9e8c77-7b32-4126-940b-b58658d0918e=%7B%22g%22%3A%22efc3e892-388d-2152-c14a-b82c0368c7f5%22%2C%22c%22%3A1719093569662%2C%22l%22%3A1719093569662%7D; crto_is_user_optout=false; crto_mapped_user_id=HupSSz8k9OkGLX4XaKttp4_KN8rB93PN; _gcl_au=1.1.78502649.1719093572; _ga=GA1.1.760330891.1719093574; FPID=FPID2.3.GNhoPiFfMBn31TF3RSxw9PIcgdMkjWxHK8xtZflB8MM%3D.1719093574; FPLC=wOgQIux60owKcljHSrRgKGl%2Bu9GxJfchjuBuaUcg7o%2BCXguA8Oa4lPq1zyGCyLDknXTiAJDOCD5KhnCshE2SgdtZ%2BhVbZAzLj41WZsZhN5REEc00ie4H%2F3Gz53j8eQ%3D%3D; FPAU=1.1.78502649.1719093572; _fbp=fb.2.1719093574676.1246992300; _gcl_aw=GCL.1719093588.CjwKCAjw7NmzBhBLEiwAxrHQ-Rs4HLt7UA1DXlqEwn4gQp249tYhjfaVciIeumObDAOlxbvnuoBdgRoCSoAQAvD_BwE; _gcl_gs=2.1.k1$i1719093569; FPGCLAW=GCL.1719093590.CjwKCAjw7NmzBhBLEiwAxrHQ-Rs4HLt7UA1DXlqEwn4gQp249tYhjfaVciIeumObDAOlxbvnuoBdgRoCSoAQAvD_BwE; _hjSessionUser_1203740=eyJpZCI6IjBlNjhhYzUzLTc2YmUtNWNjOS05ZjhhLTdmYTYzYTZlYWFlNiIsImNyZWF0ZWQiOjE3MTkwOTM1NzE2NjUsImV4aXN0aW5nIjp0cnVlfQ==; _hjSession_1203740=eyJpZCI6IjM0ZGU0ZjNlLTg0MDUtNGVhYy04MzFkLTFmZTFhMzJlNGE1YiIsImMiOjE3MTkxMDkxNTU5OTEsInMiOjAsInIiOjAsInNiIjowLCJzciI6MCwic2UiOjAsImZzIjowLCJzcCI6MX0=; 5A_COOKIE_ACCEPT=%7B%22categories%22%3A%5B%22NECESSARY%22%2C%22PERFORMANCE%22%2C%22TARGETING%22%2C%22FUNCTIONAL%22%5D%2C%22rfc_cookie%22%3Atrue%7D; cto_bundle=xVc8FV81d3habllLazQ2c0psUGZJUlJ2aEp5dFV1bFlRbXF3MmNoeDVldjMyODk1bms5ZE1XNjlLZHUlMkZDWkt6VFV0SGpSUTRiUkRqSHBSMUxwc1NXUVRJelVKdEJaTmxiMGJ0Z3cwWDNheFdXRUt6bGxKa0tEcm9Sb2prMXVLZjN4anJiVEE4a3g1a1V5Wm5QcUZyaE1sd0pybmJyekZ1T0hOd0JqcWkyWnpuNVRpNCUzRA; ab.storage.sessionId.cf9e8c77-7b32-4126-940b-b58658d0918e=%7B%22g%22%3A%22b46ddc6f-845e-9038-609b-daa145c2db42%22%2C%22e%22%3A1719111292496%2C%22c%22%3A1719109153960%2C%22l%22%3A1719109492496%7D; amplitude_id_3fbf25d58c3cce92f0e6609904a37cc9quintoandar.com.br=eyJkZXZpY2VJZCI6InhoLUxhZnJQVENuYkprc1NuWlVyUE1SbWNJRWhSVE5GNGpKZG4xcEFDZTlvYXBfb3BBc3cxUSIsInVzZXJJZCI6bnVsbCwib3B0T3V0IjpmYWxzZSwic2Vzc2lvbklkIjoxNzE5MTA5MTU0MTUzLCJsYXN0RXZlbnRUaW1lIjoxNzE5MTA5NTE1NzgwLCJldmVudElkIjoxNSwiaWRlbnRpZnlJZCI6NzAsInNlcXVlbmNlTnVtYmVyIjo4NX0=; _ga_2NHZ8V3TH0=GS1.1.1719109157.2.1.1719109521.52.0.1441122400' \
# -H 'origin: https://www.quintoandar.com.br' \
# -H 'priority: u=1, i' \
# -H 'sec-ch-ua: "Not/A)Brand";v="8", "Chromium";v="126", "Google Chrome";v="126"' \
# -H 'sec-ch-ua-mobile: ?0' \
# -H 'sec-ch-ua-platform: "Windows"' \
# -H 'sec-fetch-dest: empty' \
# -H 'sec-fetch-mode: cors' \
# -H 'sec-fetch-site: same-site' \
# -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36' \
# --data-raw '{"context":{"mapShowing":true,"listShowing":true,"userId":"xh-LafrPTCnbJksSnZUrPMRmcIEhRTNF4jJdn1pACe9oap_opAsw1Q","deviceId":"xh-LafrPTCnbJksSnZUrPMRmcIEhRTNF4jJdn1pACe9oap_opAsw1Q","numPhotos":12,"isSSR":false},"filters":{"businessContext":"SALE","blocklist":[],"selectedHouses":[],"location":{"coordinate":{"lat":-23.55052,"lng":-46.633309},"viewport":{"east":-46.564301126464834,"north":-23.468823057735495,"south":-23.6321662002967,"west":-46.702316873535146},"neighborhoods":[],"countryCode":"BR"},"priceRange":[],"specialConditions":[],"excludedSpecialConditions":[],"houseSpecs":{"area":{"range":{}},"houseTypes":["APARTMENT"],"amenities":[],"installations":[],"bathrooms":{"range":{}},"bedrooms":{"range":{}},"parkingSpace":{"range":{}}},"availability":"ANY","occupancy":"ANY","partnerIds":[],"categories":[]},"sorting":{"criteria":"RELEVANCE","order":"DESC"},"pagination":{"pageSize":12,"offset":0},"slug":"sao-paulo-sp-brasil","fields":["id","coverImage","rent","totalCost","salePrice","iptuPlusCondominium","area","imageList","imageCaptionList","address","regionName","city","visitStatus","activeSpecialConditions","type","forRent","forSale","isPrimaryMarket","bedrooms","parkingSpaces","listingTags","yield","yieldStrategy","neighbourhood","categories","bathrooms","isFurnished","installations"],"experiments":["ab_search_services_mono_pclick:1"]}'

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

offset <- c(0, seq(12, by = 11, length.out = 800))
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
  req_perform_sequential(progress = TRUE)

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
  drop_na()

write_rds(all_dfs, "imoveis.rds")

all_dfs %>% 
  mutate(installations = str_flatten_comma(installations)) %>% 
  view()

# Analysis  ---------------------------------------------------------------

escala_dinheiro <- scales::dollar_format(scale = 1e-6,
                                         suffix = "M")

all_dfs %>% 
  filter(salePrice < 15e6) %>% 
  ggplot(aes(area, salePrice)) +
  geom_point(color = "brown", alpha = 0.2) +
  scale_y_log10(labels = escala_dinheiro) +
  scale_x_log10() +
  geom_smooth(method = "lm") +
  ggpubr::stat_regline_equation()

all_dfs %>% 
  select(totalCost, salePrice,
         rent, yield) %>% 
  DataExplorer::plot_histogram(ncol = 2)

all_dfs %>%  
  ggplot(aes(factor(bedrooms), salePrice)) +
  geom_boxplot() +
  scale_y_log10(labels = scales::dollar_format())

all_dfs %>% 
  summarize(
    price = mean(salePrice),
    total_cost = mean(totalCost),
    yield = mean(yield) * 100,
    n = n(),
    .by = regionName
  ) %>% 
  filter(n > 10) %>% 
  arrange(desc(total_cost)) %>% 
  head(20)

all_dfs %>% 
  filter(str_detect(neighbourhood, "Jardim Europ")) %>% view()
  ggplot(aes(totalCost)) + geom_histogram()

all_dfs %>% 
  mutate(
    regionName = fct_lump(regionName, n = 20, other_level = "Outro"),
    regionName = fct_reorder(regionName, salePrice),
    regionName = fct_relevel(regionName, "Outro", after = Inf)
  ) %>% 
  ggplot(aes(regionName, salePrice)) +
  geom_boxplot() + 
  scale_y_log10(labels = escala_dinheiro) +
  coord_flip()

all_dfs %>% 
  mutate(installations = map(installations, \(x) paste(x, sep = ",")))



