
<!-- README.md is generated from README.Rmd. Please edit that file -->

# imoveis_quinto_andar

## Carregar pacotes e dados

``` r
library(tidyverse)
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
#> Warning: package 'tidytext' was built under R version 4.3.3
library(gt)

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
  ggplot(aes(factor(bedrooms), salePrice)) +
  geom_boxplot() +
  scale_y_log10(labels = escala_dinheiro)
```

![](README_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

## Custo por bairro em SP

``` r
imoveis %>% 
  summarize(
    price = median(salePrice),
    total_cost = mean(totalCost),
    yield = mean(yield),
    n = n(),
    .by = regionName
  ) %>% 
  filter(n > 10) %>% 
  arrange(desc(total_cost)) %>% 
  head(20) %>% 
  gt() 
```

<div id="shmdrbqass" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#shmdrbqass table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
&#10;#shmdrbqass thead, #shmdrbqass tbody, #shmdrbqass tfoot, #shmdrbqass tr, #shmdrbqass td, #shmdrbqass th {
  border-style: none;
}
&#10;#shmdrbqass p {
  margin: 0;
  padding: 0;
}
&#10;#shmdrbqass .gt_table {
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
  border-top-width: 2px;
  border-top-color: #A8A8A8;
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
&#10;#shmdrbqass .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}
&#10;#shmdrbqass .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}
&#10;#shmdrbqass .gt_subtitle {
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
&#10;#shmdrbqass .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#shmdrbqass .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#shmdrbqass .gt_col_headings {
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
&#10;#shmdrbqass .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
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
&#10;#shmdrbqass .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}
&#10;#shmdrbqass .gt_column_spanner_outer:first-child {
  padding-left: 0;
}
&#10;#shmdrbqass .gt_column_spanner_outer:last-child {
  padding-right: 0;
}
&#10;#shmdrbqass .gt_column_spanner {
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
&#10;#shmdrbqass .gt_spanner_row {
  border-bottom-style: hidden;
}
&#10;#shmdrbqass .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
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
&#10;#shmdrbqass .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}
&#10;#shmdrbqass .gt_from_md > :first-child {
  margin-top: 0;
}
&#10;#shmdrbqass .gt_from_md > :last-child {
  margin-bottom: 0;
}
&#10;#shmdrbqass .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}
&#10;#shmdrbqass .gt_stub {
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
}
&#10;#shmdrbqass .gt_stub_row_group {
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
&#10;#shmdrbqass .gt_row_group_first td {
  border-top-width: 2px;
}
&#10;#shmdrbqass .gt_row_group_first th {
  border-top-width: 2px;
}
&#10;#shmdrbqass .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#shmdrbqass .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}
&#10;#shmdrbqass .gt_first_summary_row.thick {
  border-top-width: 2px;
}
&#10;#shmdrbqass .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#shmdrbqass .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#shmdrbqass .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}
&#10;#shmdrbqass .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}
&#10;#shmdrbqass .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}
&#10;#shmdrbqass .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#shmdrbqass .gt_footnotes {
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
&#10;#shmdrbqass .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#shmdrbqass .gt_sourcenotes {
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
&#10;#shmdrbqass .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#shmdrbqass .gt_left {
  text-align: left;
}
&#10;#shmdrbqass .gt_center {
  text-align: center;
}
&#10;#shmdrbqass .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}
&#10;#shmdrbqass .gt_font_normal {
  font-weight: normal;
}
&#10;#shmdrbqass .gt_font_bold {
  font-weight: bold;
}
&#10;#shmdrbqass .gt_font_italic {
  font-style: italic;
}
&#10;#shmdrbqass .gt_super {
  font-size: 65%;
}
&#10;#shmdrbqass .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}
&#10;#shmdrbqass .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}
&#10;#shmdrbqass .gt_indent_1 {
  text-indent: 5px;
}
&#10;#shmdrbqass .gt_indent_2 {
  text-indent: 10px;
}
&#10;#shmdrbqass .gt_indent_3 {
  text-indent: 15px;
}
&#10;#shmdrbqass .gt_indent_4 {
  text-indent: 20px;
}
&#10;#shmdrbqass .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    &#10;    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="regionName">regionName</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="price">price</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="total_cost">total_cost</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="yield">yield</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="n">n</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="regionName" class="gt_row gt_left">Vila Nova Conceição</td>
<td headers="price" class="gt_row gt_right">2345000</td>
<td headers="total_cost" class="gt_row gt_right">6286.000</td>
<td headers="yield" class="gt_row gt_right">0.003250000</td>
<td headers="n" class="gt_row gt_right">18</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Itaim Bibi</td>
<td headers="price" class="gt_row gt_right">1320000</td>
<td headers="total_cost" class="gt_row gt_right">4935.536</td>
<td headers="yield" class="gt_row gt_right">0.003928571</td>
<td headers="n" class="gt_row gt_right">56</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Jardim Paulista</td>
<td headers="price" class="gt_row gt_right">1155000</td>
<td headers="total_cost" class="gt_row gt_right">4682.315</td>
<td headers="yield" class="gt_row gt_right">0.003822308</td>
<td headers="n" class="gt_row gt_right">130</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Moema</td>
<td headers="price" class="gt_row gt_right">1050000</td>
<td headers="total_cost" class="gt_row gt_right">4629.491</td>
<td headers="yield" class="gt_row gt_right">0.004243636</td>
<td headers="n" class="gt_row gt_right">110</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Paraíso</td>
<td headers="price" class="gt_row gt_right">1017500</td>
<td headers="total_cost" class="gt_row gt_right">4517.483</td>
<td headers="yield" class="gt_row gt_right">0.003848276</td>
<td headers="n" class="gt_row gt_right">58</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Campo Belo</td>
<td headers="price" class="gt_row gt_right">1150000</td>
<td headers="total_cost" class="gt_row gt_right">4439.314</td>
<td headers="yield" class="gt_row gt_right">0.004168627</td>
<td headers="n" class="gt_row gt_right">51</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Vila Olímpia</td>
<td headers="price" class="gt_row gt_right">1162500</td>
<td headers="total_cost" class="gt_row gt_right">4176.081</td>
<td headers="yield" class="gt_row gt_right">0.004228378</td>
<td headers="n" class="gt_row gt_right">74</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Vila Madalena</td>
<td headers="price" class="gt_row gt_right">1050000</td>
<td headers="total_cost" class="gt_row gt_right">4158.491</td>
<td headers="yield" class="gt_row gt_right">0.004073585</td>
<td headers="n" class="gt_row gt_right">53</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Brooklin</td>
<td headers="price" class="gt_row gt_right">1229000</td>
<td headers="total_cost" class="gt_row gt_right">4103.857</td>
<td headers="yield" class="gt_row gt_right">0.004433835</td>
<td headers="n" class="gt_row gt_right">133</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Chácara Santo Antonio</td>
<td headers="price" class="gt_row gt_right">1050000</td>
<td headers="total_cost" class="gt_row gt_right">3965.467</td>
<td headers="yield" class="gt_row gt_right">0.004453333</td>
<td headers="n" class="gt_row gt_right">15</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Pinheiros</td>
<td headers="price" class="gt_row gt_right">1160000</td>
<td headers="total_cost" class="gt_row gt_right">3900.786</td>
<td headers="yield" class="gt_row gt_right">0.004184615</td>
<td headers="n" class="gt_row gt_right">182</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Higienópolis</td>
<td headers="price" class="gt_row gt_right">1100000</td>
<td headers="total_cost" class="gt_row gt_right">3505.378</td>
<td headers="yield" class="gt_row gt_right">0.003562162</td>
<td headers="n" class="gt_row gt_right">37</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Vila Clementino</td>
<td headers="price" class="gt_row gt_right">567500</td>
<td headers="total_cost" class="gt_row gt_right">3190.667</td>
<td headers="yield" class="gt_row gt_right">0.004687037</td>
<td headers="n" class="gt_row gt_right">54</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Perdizes</td>
<td headers="price" class="gt_row gt_right">1000000</td>
<td headers="total_cost" class="gt_row gt_right">3171.959</td>
<td headers="yield" class="gt_row gt_right">0.003783505</td>
<td headers="n" class="gt_row gt_right">97</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Jardim Anália Franco</td>
<td headers="price" class="gt_row gt_right">750000</td>
<td headers="total_cost" class="gt_row gt_right">3140.717</td>
<td headers="yield" class="gt_row gt_right">0.004519565</td>
<td headers="n" class="gt_row gt_right">46</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Chácara Inglesa</td>
<td headers="price" class="gt_row gt_right">731500</td>
<td headers="total_cost" class="gt_row gt_right">3096.750</td>
<td headers="yield" class="gt_row gt_right">0.004616304</td>
<td headers="n" class="gt_row gt_right">92</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Vila Pompéia</td>
<td headers="price" class="gt_row gt_right">901000</td>
<td headers="total_cost" class="gt_row gt_right">2993.895</td>
<td headers="yield" class="gt_row gt_right">0.004311579</td>
<td headers="n" class="gt_row gt_right">95</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Vila Mariana</td>
<td headers="price" class="gt_row gt_right">694500</td>
<td headers="total_cost" class="gt_row gt_right">2949.693</td>
<td headers="yield" class="gt_row gt_right">0.004618978</td>
<td headers="n" class="gt_row gt_right">274</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Sumaré</td>
<td headers="price" class="gt_row gt_right">928500</td>
<td headers="total_cost" class="gt_row gt_right">2820.886</td>
<td headers="yield" class="gt_row gt_right">0.004254545</td>
<td headers="n" class="gt_row gt_right">44</td></tr>
    <tr><td headers="regionName" class="gt_row gt_left">Barra Funda</td>
<td headers="price" class="gt_row gt_right">630000</td>
<td headers="total_cost" class="gt_row gt_right">2752.235</td>
<td headers="yield" class="gt_row gt_right">0.004803913</td>
<td headers="n" class="gt_row gt_right">230</td></tr>
  </tbody>
  &#10;  
</table>
</div>
