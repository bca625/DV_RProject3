#Plot the percentage of Runs batted in by a single Player
teamOnBack <- joinbyteam %>% select(TM, NAME, RBI.x, R.y)%>%filter(TM != "TOT") %>% mutate(freq = (as.numeric(as.character(RBI.x))/R.y)*100) %>% arrange(desc(freq))

head(teamOnBack)