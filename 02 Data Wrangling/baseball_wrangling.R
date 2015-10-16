require(tidyr)
require(dplyr)
require("jsonlite")
require("RCurl")
require("reshape2")
require("ggplot2")


baseball <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from baseball"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_ba7433', PASS='orcl_ba7433', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

baseball2014 <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from baseball2014"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_ba7433', PASS='orcl_ba7433', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

baseball_teams <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from baseball_teams"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_ba7433', PASS='orcl_ba7433', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

baseball_pitching <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from baseball_pitching"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_ba7433', PASS='orcl_ba7433', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))



joinbyteam <- dplyr::full_join(baseball, baseball_teams, by="TM") %>% tbl_df
newbies <- dplyr::anti_join(baseball, baseball2014, by="NAME") %>% tbl_df
retirees <- dplyr::anti_join(baseball2014, baseball, by="NAME") %>% tbl_df
pitchers <- dplyr::inner_join(baseball, baseball_pitching, by="NAME") %>% tbl_df

#df <- rename(baseball, tbl = table) # table is a reserved word in Oracle so rename it to tbl.