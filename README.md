# ELT proces pre dataset Sales and Inventory Data for Retail Business Intelligence
---
## 1. Úvod a popis zdrojových dát
V rámci záverečného projektu sme sa rozhodli pracovať s voľne dostupným dataset **Sales and Inventory Data for Retail Business Intelligence** zo **Snowflake Marketplace**, poskytovaný spoločnosťou **SPS Commerce**, s cieľom vytvoriť dátový sklad (DWH) a implementovať ELT proces v prostredí Snowflake. 
Tento dataset obsahuje dáta z maloobchodného prostredia, poskytuje prehľad o predaji, zásobách a produktoch v rôznych predajniach. Pokrýva obdobie šiestich týždňov, čo umožňuje sledovať krátkodobé predajné trendy a vývoj zásob.

Vybrali sme si ho, pretože je voľne dostupný a obsahuje dáta, ktoré nám umožňujú vytvoriť dátový sklad a analyzovať predajné trendy, výkonnosť predajní a stav zásob.

Dataset podporuje biznis proces analýzy výkonnosti maloobchodného predaja. Cieľom tohto procesu je sledovanie a vyhodnocovanie predaja produktov, tržieb, zásob a marže naprieč retailermi, predajňami a geografickými lokalitami v čase. Analýza je zameraná na identifikáciu najvýkonnejších predajní a produktov, sledovanie vývoja tržieb v čase a hodnotenie ziskovosti predaja.

**Prehľad tabuliek:**
Dataset obsahuje štyri hlavné tabuľky:

- **ACTIVITY** - metriky predaja a zásob,
- **ITEM** - údaje o produktoch a ich kategorizácia,
- **LOCATION** - informácie o predajných lokalitách,
- **RETAILER_METADATA** - doplnkové informácie o retaileroch a granularita dát

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

## 3. ELT proces v Snowflake
**ELT proces:**
Dáta sú spracovávané v jednotlivých krokoch ELT procesu. V prvej fáze - Extract sú dáta prevzaté zo Snowflake Marketplace. Následne sú v rámci fázy Load uložené do staging vrstvy, ktorá zabezpečuje oddelenie zdrojových dát od analytickej vrstvy. Vo fáze Transform prebieha čistenie dát, ich úprava do dimenzionálnej podoby a tvorba faktovej tabuľky a dimenzií.