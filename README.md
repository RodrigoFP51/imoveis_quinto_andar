
<!-- README.md is generated from README.Rmd. Please edit that file -->

# imoveis_quinto_andar

## Carregar pacotes e dados

``` r
library(tidyverse, quietly = TRUE)
#> ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
#> ✔ dplyr     1.1.4     ✔ readr     2.1.5
#> ✔ forcats   1.0.0     ✔ stringr   1.5.1
#> ✔ ggplot2   3.4.4     ✔ tibble    3.2.1
#> ✔ lubridate 1.9.3     ✔ tidyr     1.3.0
#> ✔ purrr     1.0.2     
#> ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
#> ✖ dplyr::filter() masks stats::filter()
#> ✖ dplyr::lag()    masks stats::lag()
#> ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
library(tidytext)
library(gt)
library(gtExtras)

theme_set(
  theme_light()
)

imoveis <- read_rds("dados/imoveis.rds")
```

## Função para formatar valores monetários

``` r
escala_dinheiro <- scales::dollar_format(scale = 1e-6,
                                         suffix = "M")
```

## Relação de área do imóvel com valor de venda

``` r
imoveis %>% 
  filter(salePrice < 15e6) %>% 
  ggplot(aes(area, salePrice)) +
  geom_point(color = "brown", alpha = 0.2) +
  scale_y_log10(labels = escala_dinheiro) +
  scale_x_log10() +
  geom_smooth(method = "lm", color = "tomato", fill = "tomato", alpha = 0.2) 
#> `geom_smooth()` using formula = 'y ~ x'
```

![](README_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

## Relação entre número de quartos e preço do imóvel

``` r
imoveis %>% 
  ggplot(aes(factor(bedrooms), salePrice, fill = factor(bedrooms))) +
  geom_violin(width = 1.4, show.legend = FALSE) +
  geom_boxplot(width = 0.15,
               alpha = 0.2,
               color = "white",
               show.legend = FALSE) +
  scale_y_log10(labels = escala_dinheiro) +
  paletteer::scale_fill_paletteer_d("ggthemr::grape") +
  labs(x='N° de quartos', y='Valor de venda') 
#> Warning: `position_dodge()` requires non-overlapping x intervals
```

![](README_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

## Custo por região em SP

``` r
imoveis_por_regiao <- imoveis %>% 
  summarize(
    sale_price = median(salePrice),
    total_cost = median(totalCost),
    yield = mean(yield),
    n = n(),
    .by = regionName
  ) %>% 
  filter(n > 15) %>% 
  arrange(desc(sale_price)) 
  
imoveis_por_regiao %>% 
  gt(process_md = TRUE) %>% 
  cols_label(
    regionName = "Localização",
    sale_price = "Preço do Imóvel",
    total_cost = "Custo Total de Aluguel",
    yield = "Rendimento do Imóvel",
    n = "Quantidade"
  ) %>% 
  fmt_currency(
    columns = c(sale_price, total_cost),
    decimals = 0,
    currency = "BRL"
  ) %>% 
  fmt_percent(
    columns = yield,
    decimals = 2,
    drop_trailing_zeros = TRUE
  ) %>%
  tab_spanner(
    label = "Valores Medianos",
    columns = c(sale_price, total_cost)
  ) %>% 
  tab_header(
    title = "Valores de Apartamentos em diferentes regiões de SP"
  ) %>% 
  tab_source_note("Fonte: quintoandar.com.br") %>% 
  gt_theme_espn() 
```

<div id="grtazsfczp" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>@import url("https://fonts.googleapis.com/css2?family=Lato:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap");
#grtazsfczp table {
  font-family: Lato, system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
&#10;#grtazsfczp thead, #grtazsfczp tbody, #grtazsfczp tfoot, #grtazsfczp tr, #grtazsfczp td, #grtazsfczp th {
  border-style: none;
}
&#10;#grtazsfczp p {
  margin: 0;
  padding: 0;
}
&#10;#grtazsfczp .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 3px;
  border-top-color: #FFFFFF;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}
&#10;#grtazsfczp .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}
&#10;#grtazsfczp .gt_title {
  color: #333333;
  font-size: 24px;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}
&#10;#grtazsfczp .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}
&#10;#grtazsfczp .gt_heading {
  background-color: #FFFFFF;
  text-align: left;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#grtazsfczp .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#grtazsfczp .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#grtazsfczp .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 80%;
  font-weight: bolder;
  text-transform: uppercase;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}
&#10;#grtazsfczp .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 80%;
  font-weight: bolder;
  text-transform: uppercase;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}
&#10;#grtazsfczp .gt_column_spanner_outer:first-child {
  padding-left: 0;
}
&#10;#grtazsfczp .gt_column_spanner_outer:last-child {
  padding-right: 0;
}
&#10;#grtazsfczp .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}
&#10;#grtazsfczp .gt_spanner_row {
  border-bottom-style: hidden;
}
&#10;#grtazsfczp .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 80%;
  font-weight: bolder;
  text-transform: uppercase;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}
&#10;#grtazsfczp .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 80%;
  font-weight: bolder;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}
&#10;#grtazsfczp .gt_from_md > :first-child {
  margin-top: 0;
}
&#10;#grtazsfczp .gt_from_md > :last-child {
  margin-bottom: 0;
}
&#10;#grtazsfczp .gt_row {
  padding-top: 7px;
  padding-bottom: 7px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #F6F7F7;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}
&#10;#grtazsfczp .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 80%;
  font-weight: bolder;
  text-transform: uppercase;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#grtazsfczp .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}
&#10;#grtazsfczp .gt_row_group_first td {
  border-top-width: 2px;
}
&#10;#grtazsfczp .gt_row_group_first th {
  border-top-width: 2px;
}
&#10;#grtazsfczp .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#grtazsfczp .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}
&#10;#grtazsfczp .gt_first_summary_row.thick {
  border-top-width: 2px;
}
&#10;#grtazsfczp .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#grtazsfczp .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#grtazsfczp .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}
&#10;#grtazsfczp .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}
&#10;#grtazsfczp .gt_striped {
  background-color: #FAFAFA;
}
&#10;#grtazsfczp .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#grtazsfczp .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#grtazsfczp .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#grtazsfczp .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#grtazsfczp .gt_sourcenote {
  font-size: 12px;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#grtazsfczp .gt_left {
  text-align: left;
}
&#10;#grtazsfczp .gt_center {
  text-align: center;
}
&#10;#grtazsfczp .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}
&#10;#grtazsfczp .gt_font_normal {
  font-weight: normal;
}
&#10;#grtazsfczp .gt_font_bold {
  font-weight: bold;
}
&#10;#grtazsfczp .gt_font_italic {
  font-style: italic;
}
&#10;#grtazsfczp .gt_super {
  font-size: 65%;
}
&#10;#grtazsfczp .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}
&#10;#grtazsfczp .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}
&#10;#grtazsfczp .gt_indent_1 {
  text-indent: 5px;
}
&#10;#grtazsfczp .gt_indent_2 {
  text-indent: 10px;
}
&#10;#grtazsfczp .gt_indent_3 {
  text-indent: 15px;
}
&#10;#grtazsfczp .gt_indent_4 {
  text-indent: 20px;
}
&#10;#grtazsfczp .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_heading">
      <td colspan="5" class="gt_heading gt_title gt_font_normal gt_bottom_border" style>Valores de Apartamentos em diferentes regiões de SP</td>
    </tr>
    &#10;    <tr class="gt_col_headings gt_spanner_row">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" scope="col" id="Localização">Localização</th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="Valores Medianos">
        <span class="gt_column_spanner">Valores Medianos</span>
      </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="2" colspan="1" scope="col" id="Rendimento do Imóvel">Rendimento do Imóvel</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="2" colspan="1" scope="col" id="Quantidade">Quantidade</th>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Preço do Imóvel">Preço do Imóvel</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Custo Total de Aluguel">Custo Total de Aluguel</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="regionName" class="gt_row gt_left">Vila Nova Conceição</td>
<td headers="sale_price" class="gt_row gt_right">R$2,345,000</td>
<td headers="total_cost" class="gt_row gt_right">R$4,204</td>
<td headers="yield" class="gt_row gt_right">0.32%</td>
<td headers="n" class="gt_row gt_right">18</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left gt_striped">Itaim Bibi</td>
<td headers="sale_price" class="gt_row gt_right gt_striped">R$1,320,000</td>
<td headers="total_cost" class="gt_row gt_right gt_striped">R$4,414</td>
<td headers="yield" class="gt_row gt_right gt_striped">0.39%</td>
<td headers="n" class="gt_row gt_right gt_striped">56</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Brooklin</td>
<td headers="sale_price" class="gt_row gt_right">R$1,229,000</td>
<td headers="total_cost" class="gt_row gt_right">R$2,300</td>
<td headers="yield" class="gt_row gt_right">0.44%</td>
<td headers="n" class="gt_row gt_right">133</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left gt_striped">Vila Olímpia</td>
<td headers="sale_price" class="gt_row gt_right gt_striped">R$1,162,500</td>
<td headers="total_cost" class="gt_row gt_right gt_striped">R$2,704</td>
<td headers="yield" class="gt_row gt_right gt_striped">0.42%</td>
<td headers="n" class="gt_row gt_right gt_striped">74</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Pinheiros</td>
<td headers="sale_price" class="gt_row gt_right">R$1,160,000</td>
<td headers="total_cost" class="gt_row gt_right">R$2,290</td>
<td headers="yield" class="gt_row gt_right">0.42%</td>
<td headers="n" class="gt_row gt_right">182</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left gt_striped">Jardim Paulista</td>
<td headers="sale_price" class="gt_row gt_right gt_striped">R$1,155,000</td>
<td headers="total_cost" class="gt_row gt_right gt_striped">R$3,554</td>
<td headers="yield" class="gt_row gt_right gt_striped">0.38%</td>
<td headers="n" class="gt_row gt_right gt_striped">130</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Campo Belo</td>
<td headers="sale_price" class="gt_row gt_right">R$1,150,000</td>
<td headers="total_cost" class="gt_row gt_right">R$3,314</td>
<td headers="yield" class="gt_row gt_right">0.42%</td>
<td headers="n" class="gt_row gt_right">51</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left gt_striped">Higienópolis</td>
<td headers="sale_price" class="gt_row gt_right gt_striped">R$1,100,000</td>
<td headers="total_cost" class="gt_row gt_right gt_striped">R$2,495</td>
<td headers="yield" class="gt_row gt_right gt_striped">0.36%</td>
<td headers="n" class="gt_row gt_right gt_striped">37</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Moema</td>
<td headers="sale_price" class="gt_row gt_right">R$1,050,000</td>
<td headers="total_cost" class="gt_row gt_right">R$3,070</td>
<td headers="yield" class="gt_row gt_right">0.42%</td>
<td headers="n" class="gt_row gt_right">110</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left gt_striped">Vila Madalena</td>
<td headers="sale_price" class="gt_row gt_right gt_striped">R$1,050,000</td>
<td headers="total_cost" class="gt_row gt_right gt_striped">R$3,395</td>
<td headers="yield" class="gt_row gt_right gt_striped">0.41%</td>
<td headers="n" class="gt_row gt_right gt_striped">53</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Paraíso</td>
<td headers="sale_price" class="gt_row gt_right">R$1,017,500</td>
<td headers="total_cost" class="gt_row gt_right">R$3,968</td>
<td headers="yield" class="gt_row gt_right">0.38%</td>
<td headers="n" class="gt_row gt_right">58</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left gt_striped">Perdizes</td>
<td headers="sale_price" class="gt_row gt_right gt_striped">R$1,000,000</td>
<td headers="total_cost" class="gt_row gt_right gt_striped">R$2,500</td>
<td headers="yield" class="gt_row gt_right gt_striped">0.38%</td>
<td headers="n" class="gt_row gt_right gt_striped">97</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Sumaré</td>
<td headers="sale_price" class="gt_row gt_right">R$928,500</td>
<td headers="total_cost" class="gt_row gt_right">R$2,324</td>
<td headers="yield" class="gt_row gt_right">0.43%</td>
<td headers="n" class="gt_row gt_right">44</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left gt_striped">Vila Pompéia</td>
<td headers="sale_price" class="gt_row gt_right gt_striped">R$901,000</td>
<td headers="total_cost" class="gt_row gt_right gt_striped">R$1,725</td>
<td headers="yield" class="gt_row gt_right gt_striped">0.43%</td>
<td headers="n" class="gt_row gt_right gt_striped">95</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Vila Romana</td>
<td headers="sale_price" class="gt_row gt_right">R$785,000</td>
<td headers="total_cost" class="gt_row gt_right">R$1,759</td>
<td headers="yield" class="gt_row gt_right">0.44%</td>
<td headers="n" class="gt_row gt_right">23</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left gt_striped">Jardim Anália Franco</td>
<td headers="sale_price" class="gt_row gt_right gt_striped">R$750,000</td>
<td headers="total_cost" class="gt_row gt_right gt_striped">R$2,146</td>
<td headers="yield" class="gt_row gt_right gt_striped">0.45%</td>
<td headers="n" class="gt_row gt_right gt_striped">46</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Chácara Inglesa</td>
<td headers="sale_price" class="gt_row gt_right">R$731,500</td>
<td headers="total_cost" class="gt_row gt_right">R$1,620</td>
<td headers="yield" class="gt_row gt_right">0.46%</td>
<td headers="n" class="gt_row gt_right">92</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left gt_striped">Saúde</td>
<td headers="sale_price" class="gt_row gt_right gt_striped">R$710,000</td>
<td headers="total_cost" class="gt_row gt_right gt_striped">R$1,346</td>
<td headers="yield" class="gt_row gt_right gt_striped">0.42%</td>
<td headers="n" class="gt_row gt_right gt_striped">70</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Vila Mariana</td>
<td headers="sale_price" class="gt_row gt_right">R$694,500</td>
<td headers="total_cost" class="gt_row gt_right">R$1,880</td>
<td headers="yield" class="gt_row gt_right">0.46%</td>
<td headers="n" class="gt_row gt_right">274</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left gt_striped">Tatuapé</td>
<td headers="sale_price" class="gt_row gt_right gt_striped">R$651,000</td>
<td headers="total_cost" class="gt_row gt_right gt_striped">R$1,246</td>
<td headers="yield" class="gt_row gt_right gt_striped">0.46%</td>
<td headers="n" class="gt_row gt_right gt_striped">170</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Barra Funda</td>
<td headers="sale_price" class="gt_row gt_right">R$630,000</td>
<td headers="total_cost" class="gt_row gt_right">R$2,100</td>
<td headers="yield" class="gt_row gt_right">0.48%</td>
<td headers="n" class="gt_row gt_right">230</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left gt_striped">Ipiranga</td>
<td headers="sale_price" class="gt_row gt_right gt_striped">R$589,500</td>
<td headers="total_cost" class="gt_row gt_right gt_striped">R$1,398</td>
<td headers="yield" class="gt_row gt_right gt_striped">0.47%</td>
<td headers="n" class="gt_row gt_right gt_striped">218</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Vila Santa Clara</td>
<td headers="sale_price" class="gt_row gt_right">R$580,000</td>
<td headers="total_cost" class="gt_row gt_right">R$835</td>
<td headers="yield" class="gt_row gt_right">0.46%</td>
<td headers="n" class="gt_row gt_right">16</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left gt_striped">Vila Maria </td>
<td headers="sale_price" class="gt_row gt_right gt_striped">R$580,000</td>
<td headers="total_cost" class="gt_row gt_right gt_striped">R$746</td>
<td headers="yield" class="gt_row gt_right gt_striped">0.43%</td>
<td headers="n" class="gt_row gt_right gt_striped">22</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Bosque da Saúde</td>
<td headers="sale_price" class="gt_row gt_right">R$575,000</td>
<td headers="total_cost" class="gt_row gt_right">R$1,812</td>
<td headers="yield" class="gt_row gt_right">0.48%</td>
<td headers="n" class="gt_row gt_right">154</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left gt_striped">Aclimação</td>
<td headers="sale_price" class="gt_row gt_right gt_striped">R$570,000</td>
<td headers="total_cost" class="gt_row gt_right gt_striped">R$1,838</td>
<td headers="yield" class="gt_row gt_right gt_striped">0.46%</td>
<td headers="n" class="gt_row gt_right gt_striped">159</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Vila Clementino</td>
<td headers="sale_price" class="gt_row gt_right">R$567,500</td>
<td headers="total_cost" class="gt_row gt_right">R$2,912</td>
<td headers="yield" class="gt_row gt_right">0.47%</td>
<td headers="n" class="gt_row gt_right">54</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left gt_striped">Santa Cecília</td>
<td headers="sale_price" class="gt_row gt_right gt_striped">R$499,000</td>
<td headers="total_cost" class="gt_row gt_right gt_striped">R$2,100</td>
<td headers="yield" class="gt_row gt_right gt_striped">0.46%</td>
<td headers="n" class="gt_row gt_right gt_striped">347</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Santana</td>
<td headers="sale_price" class="gt_row gt_right">R$490,000</td>
<td headers="total_cost" class="gt_row gt_right">R$1,433</td>
<td headers="yield" class="gt_row gt_right">0.46%</td>
<td headers="n" class="gt_row gt_right">247</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left gt_striped">Consolação</td>
<td headers="sale_price" class="gt_row gt_right gt_striped">R$485,500</td>
<td headers="total_cost" class="gt_row gt_right gt_striped">R$2,064</td>
<td headers="yield" class="gt_row gt_right gt_striped">0.48%</td>
<td headers="n" class="gt_row gt_right gt_striped">310</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Mandaqui</td>
<td headers="sale_price" class="gt_row gt_right">R$480,000</td>
<td headers="total_cost" class="gt_row gt_right">R$1,477</td>
<td headers="yield" class="gt_row gt_right">0.44%</td>
<td headers="n" class="gt_row gt_right">31</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left gt_striped">Mooca</td>
<td headers="sale_price" class="gt_row gt_right gt_striped">R$470,000</td>
<td headers="total_cost" class="gt_row gt_right gt_striped">R$1,557</td>
<td headers="yield" class="gt_row gt_right gt_striped">0.5%</td>
<td headers="n" class="gt_row gt_right gt_striped">762</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Bela Vista</td>
<td headers="sale_price" class="gt_row gt_right">R$450,000</td>
<td headers="total_cost" class="gt_row gt_right">R$2,540</td>
<td headers="yield" class="gt_row gt_right">0.49%</td>
<td headers="n" class="gt_row gt_right">400</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left gt_striped">Casa Verde</td>
<td headers="sale_price" class="gt_row gt_right gt_striped">R$450,000</td>
<td headers="total_cost" class="gt_row gt_right gt_striped">R$1,560</td>
<td headers="yield" class="gt_row gt_right gt_striped">0.49%</td>
<td headers="n" class="gt_row gt_right gt_striped">116</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Vila Guilherme</td>
<td headers="sale_price" class="gt_row gt_right">R$450,000</td>
<td headers="total_cost" class="gt_row gt_right">R$1,206</td>
<td headers="yield" class="gt_row gt_right">0.49%</td>
<td headers="n" class="gt_row gt_right">122</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left gt_striped">Água Fria</td>
<td headers="sale_price" class="gt_row gt_right gt_striped">R$438,170</td>
<td headers="total_cost" class="gt_row gt_right gt_striped">R$2,157</td>
<td headers="yield" class="gt_row gt_right gt_striped">0.49%</td>
<td headers="n" class="gt_row gt_right gt_striped">68</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Vila Prudente</td>
<td headers="sale_price" class="gt_row gt_right">R$425,000</td>
<td headers="total_cost" class="gt_row gt_right">R$1,436</td>
<td headers="yield" class="gt_row gt_right">0.49%</td>
<td headers="n" class="gt_row gt_right">146</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left gt_striped">Belém</td>
<td headers="sale_price" class="gt_row gt_right gt_striped">R$424,500</td>
<td headers="total_cost" class="gt_row gt_right gt_striped">R$1,628</td>
<td headers="yield" class="gt_row gt_right gt_striped">0.5%</td>
<td headers="n" class="gt_row gt_right gt_striped">208</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Bom Retiro</td>
<td headers="sale_price" class="gt_row gt_right">R$400,000</td>
<td headers="total_cost" class="gt_row gt_right">R$1,955</td>
<td headers="yield" class="gt_row gt_right">0.53%</td>
<td headers="n" class="gt_row gt_right">139</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left gt_striped">Água Branca</td>
<td headers="sale_price" class="gt_row gt_right gt_striped">R$390,000</td>
<td headers="total_cost" class="gt_row gt_right gt_striped">R$2,312</td>
<td headers="yield" class="gt_row gt_right gt_striped">0.52%</td>
<td headers="n" class="gt_row gt_right gt_striped">93</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Cambuci</td>
<td headers="sale_price" class="gt_row gt_right">R$379,500</td>
<td headers="total_cost" class="gt_row gt_right">R$1,857</td>
<td headers="yield" class="gt_row gt_right">0.51%</td>
<td headers="n" class="gt_row gt_right">350</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left gt_striped">Campos Elíseos</td>
<td headers="sale_price" class="gt_row gt_right gt_striped">R$360,000</td>
<td headers="total_cost" class="gt_row gt_right gt_striped">R$1,754</td>
<td headers="yield" class="gt_row gt_right gt_striped">0.47%</td>
<td headers="n" class="gt_row gt_right gt_striped">92</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Freguesia do Ó</td>
<td headers="sale_price" class="gt_row gt_right">R$360,000</td>
<td headers="total_cost" class="gt_row gt_right">R$1,207</td>
<td headers="yield" class="gt_row gt_right">0.48%</td>
<td headers="n" class="gt_row gt_right">34</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left gt_striped">Vila das Mercês</td>
<td headers="sale_price" class="gt_row gt_right gt_striped">R$352,000</td>
<td headers="total_cost" class="gt_row gt_right gt_striped">R$818</td>
<td headers="yield" class="gt_row gt_right gt_striped">0.53%</td>
<td headers="n" class="gt_row gt_right gt_striped">69</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Vila Roque</td>
<td headers="sale_price" class="gt_row gt_right">R$327,500</td>
<td headers="total_cost" class="gt_row gt_right">R$645</td>
<td headers="yield" class="gt_row gt_right">0.48%</td>
<td headers="n" class="gt_row gt_right">18</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left gt_striped">Canindé</td>
<td headers="sale_price" class="gt_row gt_right gt_striped">R$325,500</td>
<td headers="total_cost" class="gt_row gt_right gt_striped">R$2,076</td>
<td headers="yield" class="gt_row gt_right gt_striped">0.52%</td>
<td headers="n" class="gt_row gt_right gt_striped">24</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Liberdade</td>
<td headers="sale_price" class="gt_row gt_right">R$320,000</td>
<td headers="total_cost" class="gt_row gt_right">R$1,800</td>
<td headers="yield" class="gt_row gt_right">0.52%</td>
<td headers="n" class="gt_row gt_right">410</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left gt_striped">Brás</td>
<td headers="sale_price" class="gt_row gt_right gt_striped">R$315,000</td>
<td headers="total_cost" class="gt_row gt_right gt_striped">R$1,825</td>
<td headers="yield" class="gt_row gt_right gt_striped">0.52%</td>
<td headers="n" class="gt_row gt_right gt_striped">115</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Parque Novo Mundo </td>
<td headers="sale_price" class="gt_row gt_right">R$310,000</td>
<td headers="total_cost" class="gt_row gt_right">R$1,904</td>
<td headers="yield" class="gt_row gt_right">0.5%</td>
<td headers="n" class="gt_row gt_right">30</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left gt_striped">Centro</td>
<td headers="sale_price" class="gt_row gt_right gt_striped">R$300,000</td>
<td headers="total_cost" class="gt_row gt_right gt_striped">R$1,568</td>
<td headers="yield" class="gt_row gt_right gt_striped">0.49%</td>
<td headers="n" class="gt_row gt_right gt_striped">212</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Sacomã</td>
<td headers="sale_price" class="gt_row gt_right">R$293,000</td>
<td headers="total_cost" class="gt_row gt_right">R$800</td>
<td headers="yield" class="gt_row gt_right">0.52%</td>
<td headers="n" class="gt_row gt_right">36</td></tr>
  </tbody>
  <tfoot class="gt_sourcenotes">
    <tr>
      <td class="gt_sourcenote" colspan="5">Fonte: quintoandar.com.br</td>
    </tr>
  </tfoot>
  &#10;</table>
</div>

## Preço médio por unidade de instalação no predio

``` r
library(tidytext)
imoveis %>% 
  unnest_tokens(palavra, installations) %>% 
  summarize(
    sale_price = mean(salePrice),
    .by = palavra
  ) %>% 
  mutate(palavra = fct_reorder(palavra, sale_price)) %>% 
  ggplot(aes(palavra, sale_price)) + 
  geom_segment(aes(x=palavra, xend=palavra, y=0, yend=sale_price),
               lty = 2) +
  geom_point(size = 3.6) +
  scale_y_continuous(labels = escala_dinheiro) +
  coord_flip() +
  labs(x='', y='')
```

![](README_files/figure-gfm/unnamed-chunk-7-1.png)<!-- --> \## Preço de
venda do imóvel X Rendimento do Aluguel

``` r
imoveis %>% 
  ggplot(aes(yield, salePrice)) +
  geom_point(size = 2.2, alpha = 0.3, color = "#824D74") +
  scale_y_continuous(labels = escala_dinheiro) +
  scale_x_continuous(labels = scales::percent_format()) +
  geom_smooth(method = "loess", color = "#401F71")
#> `geom_smooth()` using formula = 'y ~ x'
```

![](README_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->
