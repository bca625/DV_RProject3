require(tidyr)
require(dplyr)
require("jsonlite")
require("RCurl")
require("reshape2")
require("ggplot2")


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