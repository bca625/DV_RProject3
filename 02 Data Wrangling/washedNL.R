#Plot National League Rookie RBIs by Team
washedNL <- retirees %>% select(TM, NAME, RBI, LG, AGE) %>% filter(LG=="NL")

ggplot() + 
  coord_cartesian() + 
  scale_x_discrete() +
  scale_y_continuous() +
  labs(title='National League Retiree Age by Team') +
  labs(x="Team", y=paste("Age")) +
  layer(data=washedNL, 
        mapping=aes(x=TM, y=as.numeric(as.character(AGE)), color=as.character(TM)), 
        stat="identity", 
        stat_params=list(),
        geom="point",
        geom_params=list(), 
        #position=position_identity()
        position=position_jitter(width=0.3, height=0)
  )