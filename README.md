# DT-zaverecny-projekt
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
