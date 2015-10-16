setwd("~/Assignments/UT Austin/Data Vis/DV_RProject3/01 Data") ###

file_path <- "baseball_pitching.csv"

baseball <- read.csv(file_path, stringsAsFactors = FALSE)

# Replace "." (i.e., period) with "_" in the column names.
names(baseball) <- gsub("\\.+", "_", names(baseball))

str(baseball) # Uncomment this and  run just the lines to here to get column types to use for getting the list of measures.

measures <- c("Rk","Age","W","L","WL","ERA","G","GS","GF","CG","SHO","SV","IP","H","R","ER","HR","BB","IBB","SO","HBP","BK","WP","BF","ERAplus","FIP","WHIP","Hnine","HRnine","BBnine","SOnine","SOW")
#measures <- NA # Do this if there are no measures.

# Get rid of special characters in each column.
# Google ASCII Table to understand the following:
for(n in names(baseball)) {
  baseball[n] <- data.frame(lapply(baseball[n], gsub, pattern="[^ -~]",replacement= ""))
}

dimensions <- setdiff(names(baseball), measures)
if( length(measures) > 1 || ! is.na(dimensions)) {
  for(d in dimensions) {
    # Get rid of " and ' in dimensions.
    baseball[d] <- data.frame(lapply(baseball[d], gsub, pattern="[\"']",replacement= ""))
    # Change & to and in dimensions.
    baseball[d] <- data.frame(lapply(baseball[d], gsub, pattern="&",replacement= " and "))
    # Change : to ; in dimensions.
    baseball[d] <- data.frame(lapply(baseball[d], gsub, pattern=":",replacement= ";"))
  }
}

library(lubridate)
# Fix date columns, this needs to be done by hand because | needs to be correct.
#                                                        \_/


# The following is an example of dealing with special cases like making state abbreviations be all upper case.
# baseball["State"] <- data.frame(lapply(baseball["State"], toupper))

#Get rid of all characters in measures except for numbers, the - sign, and period.dimensions
if( length(measures) > 1 || ! is.na(measures)) {
  for(m in measures) {
    baseball[m] <- data.frame(lapply(baseball[m], gsub, pattern="[^--.0-9]",replacement= ""))
  }
}

write.csv(baseball, paste(gsub(".csv", "", file_path), ".reformatted.csv", sep=""), row.names=FALSE, na = "")

tableName <- gsub(" +", "_", gsub("[^A-z, 0-9, ]", "", gsub(".csv", "", file_path)))
sql <- paste("CREATE TABLE", tableName, "(\n-- Change table_name to the table name you want.\n")
if( length(measures) > 1 || ! is.na(dimensions)) {
  for(d in dimensions) {
    sql <- paste(sql, paste(d, "varchar2(4000),\n"))
  }
}
if( length(measures) > 1 || ! is.na(measures)) {
  for(m in measures) {
    if(m != tail(measures, n=1)) sql <- paste(sql, paste(m, "number(38,4),\n"))
    else sql <- paste(sql, paste(m, "number(38,4)\n"))
  }
}
sql <- paste(sql, ");")
cat(sql)
