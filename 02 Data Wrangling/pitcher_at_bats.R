require(tidyr)
require(dplyr)
require("jsonlite")
require("RCurl")
require("reshape2")
require("ggplot2")


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