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



#Plot American League Rookie RBIs by Team
rookieAL <- newbies %>% select(TM, NAME, RBI, LG) %>% filter(LG=="AL")

ggplot() + 
  coord_cartesian() + 
  scale_x_discrete() +
  scale_y_continuous() +
  labs(title='American League Rookie RBIs by Team') +
  labs(x="Team", y=paste("Runs Batted In")) +
  layer(data=rookieAL, 
        mapping=aes(x=TM, y=as.numeric(as.character(RBI)), color=as.character(TM)), 
        stat="identity", 
        stat_params=list(),
        geom="point",
        geom_params=list(), 
        #position=position_identity()
        position=position_jitter(width=0.3, height=0)
  )



#Plot National League Rookie RBIs by Team
rookieNL <- newbies %>% select(TM, NAME, RBI, LG) %>% filter(LG=="NL")

ggplot() + 
  coord_cartesian() + 
  scale_x_discrete() +
  scale_y_continuous() +
  labs(title='National League Rookie RBIs by Team') +
  labs(x="Team", y=paste("Runs Batted In")) +
  layer(data=rookieNL, 
        mapping=aes(x=TM, y=as.numeric(as.character(RBI)), color=as.character(TM)), 
        stat="identity", 
        stat_params=list(),
        geom="point",
        geom_params=list(), 
        #position=position_identity()
        position=position_jitter(width=0.3, height=0)
  )


#Plot National League Rookie RBIs by Team
washedNL <- retirees %>% select(TM, NAME, RBI, LG) %>% filter(LG=="NL")

ggplot() + 
  coord_cartesian() + 
  scale_x_discrete() +
  scale_y_continuous() +
  labs(title='National League Retiree Age by Team') +
  labs(x="Team", y=paste("Runs Batted In")) +
  layer(data=washedNL, 
        mapping=aes(x=TM, y=as.numeric(as.character(AGE)), color=as.character(TM)), 
        stat="identity", 
        stat_params=list(),
        geom="point",
        geom_params=list(), 
        #position=position_identity()
        position=position_jitter(width=0.3, height=0)
  )



#National League Pitchers (Talk about Designated Hitter Rule)
pitchersAB <- pitchers %>% select(TM.x, NAME, RBI, AB, ERA, LG.x)%>%filter(LG.x != "MLB")

ggplot() + 
  coord_cartesian() + 
  scale_x_discrete() +
  scale_y_continuous() +
  labs(title='National League and American League Pitchers At Bats') +
  labs(x="League", y=paste("At Bats")) +
  layer(data=pitchersAB, 
        mapping=aes(x=LG.x, y=as.numeric(as.character(AB)), color=as.character(TM.x)), 
        stat="identity", 
        stat_params=list(),
        geom="point",
        geom_params=list(), 
        #position=position_identity()
        position=position_jitter(width=0.3, height=0)
  )



#Plot the percentage of Runs batted in by a single Player
teamOnBack <- joinbyteam %>% select(TM, AGE, NAME, RBI.x, R.y, LG)%>%filter(TM != "TOT", TM != "null",TM != "LgAvg") %>% mutate(freq = (as.numeric(as.character(RBI.x))/R.y)*100) %>% arrange(desc(freq))

teamOnBackAL <- teamOnBack %>% filter(LG == "AL")

ggplot() + 
  coord_cartesian() + 
  scale_x_discrete() +
  scale_y_continuous() +
  labs(title='Player Run Percentage By Team (American League)') +
  labs(x="Team", y=paste("Run Percentage")) +
  layer(data=teamOnBackAL, 
        mapping=aes(x=TM, y=freq, color=as.character(TM)), 
        stat="identity", 
        stat_params=list(),
        geom="point",
        geom_params=list(), 
        #position=position_identity()
        position=position_jitter(width=0.3, height=0)
  )


teamOnBackNL <- teamOnBack %>% filter(LG == "NL")

ggplot() + 
  coord_cartesian() + 
  scale_x_discrete() +
  scale_y_continuous() +
  labs(title='Player Run Percentage By Team (National League)') +
  labs(x="Team", y=paste("Run Percentage")) +
  layer(data=teamOnBackNL, 
        mapping=aes(x=TM, y=freq, color=as.character(TM)), 
        stat="identity", 
        stat_params=list(),
        geom="point",
        geom_params=list(), 
        #position=position_identity()
        position=position_jitter(width=0.3, height=0)
  )



#df <- rename(baseball, tbl = table) # table is a reserved word in Oracle so rename it to tbl.