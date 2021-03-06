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