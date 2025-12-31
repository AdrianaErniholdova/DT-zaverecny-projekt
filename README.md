# ELT proces datasetu Sales and Inventory Data for Retail Business Intelligence
Tento projekt predstavuje implementáciu ELT procesu v prostredí Snowflake a vytvorenie dátového skladu (DWH) so Star schémou.
---
## 1. Úvod a popis zdrojových dát
V projekte pracujeme s voľne dostupným datasetom **Sales and Inventory Data for Retail Business Intelligence**, ktorý pochádza zo **Snowflake Marketplace** a je poskytovaný spoločnosťou **SPS Commerce**. 

Vybrali sme si ho, pretože obsahuje reálne dáta o predaji, zásobách a produktoch z viacerých predajní, ktoré sa dajú využiť na zistenie predajných trendov, kontrolu zásob a porovnanie predajov medzi jednotlivými obchodmi.

Dataset obsahuje štyri hlavné tabuľky:

- **ACTIVITY** - metriky predaja a zásob,
- **ITEM** - údaje o produktoch a ich kategorizácia,
- **LOCATION** - informácie o predajných lokalitách,
- **RETAILER_METADATA** - doplnkové informácie o retaileroch a granularita dát

Účelom ELT procesu je tieto dáta **extrahovať, transformovať a uložiť** do dimenzionálneho modelu.
---
## 1.1 Dátová architektúra

### ERD diagram
Diagram zobrazuje hlavné entity datasetu a vzťahy medzi nimi.

*Entitno-relačný diagram pôvodnej dátovej štruktúry:*
![erd](img/erd_schema.png)

## 2. Dimenzionálny model
Navrhnutá Star Schema je tvorená jednou tabuľkou faktov a piatimi dimenzionálnymi tabuľkami.
- **fact_sales** - tabuľka faktov, ktorá predstavuje metriky predaja a obsahuje atribúty:
  - `id_fact_sales` - primárny kľúč
  - `id_dim_retailer`, `id_dim_item`, `id_dim_location`, `id_dim_date`, `id_dim_store` - cudzie kľúče napojené na všetky dimenzie
  - `net_sales_units`- počet predaných kusov
  - `net_sales_retail` - tržby z predaja
  - `inventory_units` - počet kusov na sklade
  - `retail_price` - maloobchodná cena
  - `corporate_cost` - nákladová cena
    
- **dim_item** - dimenzia produktu, obsahuje id, kategóriu produktu, skupinu, farbu, veľkosť, pohlavie a cenu za kus. SCD Typ 2
- **dim_location** - dimenzia lokality, obsahuje id, mesto, štát, PSČ a krajinu. SCD Typ 1
- **dim_retailer** - dimenzia predajcu, obsahuje id, názov predajcu. SCD Typ 3
- **dim_store** - dimenzia predajne, obsahuje id, názov predajne, číslo, typ predajne, a typ nákupného centra, v ktorom sa nachádza. SCD Typ 1
- **dim_date** - dimenzia času, obsahuje id, dátum, deň, týždeň, mesiac, kvartál a rok. SCD Typ 0

Všetky dimenzie majú k faktovej tabuľke vzťah 1:N
 
*Hviezdicový model (Star Schema):*
![erd](img/star_schema.png)