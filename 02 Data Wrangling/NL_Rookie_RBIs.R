require(tidyr)
require(dplyr)
require("jsonlite")
require("RCurl")
require("reshape2")
require("ggplot2")

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