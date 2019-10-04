
#Statistics Analysis Global Enviroment 


#Loadinbg the required data:

activities <- read.csv("../www/data/activities_processed.csv")
school <- read.csv("../www/data/school.csv")
crime <- read.csv("../www/data/teen_data.csv")
crime_hour_boro = read.csv("../../output/crimeweighted_hour_boro.csv")



crime#Pie chart statistics of crime:
library(googleVis)
library(dplyr)
library(data.table)
library(tidyverse)



crime_type <- data.frame(type= c("Felony", "Misdemeanor", "Violation"),amount=c(4096,8992,3353 ))
crime_sex <- data.frame(sex= c("Female", "Male"),amount=c(9056,7385))
crime_race <- data.frame(race=c("American Indian/Alaska Native", "Asian/Pacific Islander", "Black", "Black Hispanic", 
                                "White", "White Hispanic"), amount=c(83,1147,6414,1297,1819,4965))

crime_type_count <- gvisPieChart(crime_type,options=list(
  width=700,
  height=700,
  legend= 'none',
  title='The Crime Severity Distribution Chart',
  titleTextStyle="{fontSize: 22}",
  colors="['red','orange','yellow']",
  pieSliceText=' ',
  pieHole=0.4, chartid="doughnut"))

crime_sex_count <- gvisPieChart(crime_sex,options=list(
  width=700,
  height=700,
  legend= 'none',
  title='The Crime Victim Sex Distribution Chart',
  titleTextStyle="{fontSize: 22}",
  colors="['red','blue']",
  pieSliceText=' ',
  pieHole=0.4, chartid="doughnut"))

crime_race_count <- gvisPieChart(crime_race,options=list(
  width=700,
  height=700,
  legend= 'none',
  title='The Crime Victim Race Distribution Chart',
  titleTextStyle="{fontSize: 22}",
  colors="['red','orange','green','blue','purple','yellow']",
  pieSliceText=' ',
  pieHole=0.4, chartid="doughnut"))


violation_crime <- crime[crime$LAW_CAT_CD =="VIOLATION",]
misdemeanor_crime <- crime[crime$LAW_CAT_CD =="MISDEMEANOR",]
felony_crime <- crime[crime$LAW_CAT_CD =="FELONY",]

#names(hour_crime_df)<-c("Time","Amount")
violation_crime_tm <- as.POSIXct(violation_crime$CMPLNT_FR_TM,format="%H:%M:%OS")
misdemeanor_crime_tm <- as.POSIXct(misdemeanor_crime$CMPLNT_FR_TM,format="%H:%M:%OS")
felony_crime_tm <- as.POSIXct(felony_crime$CMPLNT_FR_TM,format="%H:%M:%OS")
violation_crime_tm_hour <- cut(violation_crime_tm,breaks="hour")
misdemeanor_crime_tm_hour <- cut(misdemeanor_crime_tm,breaks="hour")
felony_crime_tm_hour <- cut(felony_crime_tm,breaks="hour")

violation_hour_crime_df <- data.frame(table(violation_crime_tm_hour))
violation_hour_crime_df <- mutate(violation_hour_crime_df,violation_crime_tm_hour=substr(violation_crime_tm_hour, 12,19))
misdemeanor_hour_crime_df <- data.frame(table(misdemeanor_crime_tm_hour))
misdemeanor_hour_crime_df <- mutate(misdemeanor_hour_crime_df,misdemeanor_crime_tm_hour=substr(misdemeanor_crime_tm_hour, 12,19))
felony_hour_crime_df <- data.frame(table(felony_crime_tm_hour))
felony_hour_crime_df <- mutate(felony_hour_crime_df,felony_crime_tm_hour=substr(felony_crime_tm_hour, 12,19))

hour_count_summary <- cbind(violation_hour_crime_df,misdemeanor_hour_crime_df,felony_hour_crime_df)
hour_count_summary  <- hour_count_summary[,c(1,2,4,6)]

names(hour_count_summary)[names(hour_count_summary) == "violation_crime_tm_hour"] <- "Hour"
names(hour_count_summary)[names(hour_count_summary) == "Freq"] <- "Violation_Freq"
names(hour_count_summary)[names(hour_count_summary) == "Freq.1"] <- "Misdemeanor_Freq"
names(hour_count_summary)[names(hour_count_summary) == "Freq.2"] <- "Felony_Freq"

plot2 <- plot_ly(data.frame(hour_count_summary), x = hour_count_summary$Hour)%>%
  add_lines(y = hour_count_summary$Violation_Freq, name = 'Violation') %>%
  add_lines(y = hour_count_summary$Misdemeanor_Freq, name = 'Misdemeanor') %>%
  add_lines(y = hour_count_summary$Felony_Freq, name = 'Felony') %>%
  layout(
    title = "The Number of Crimes by 24 hours ",
    xaxis = list(title="Time",
                 showbackground = F),
    yaxis = list(title = "Number of Crime Reported By Hour"),
    paper_bgcolor = rgb(1,1,1,0)
  )

#################################################

plot_muliti_crime <-ggplot(crime_hour_boro, aes(hour, crime_weighted, color = boro)) + geom_line() +
  ggtitle("Crime index") +
  labs (x = "time", y = "crime_index") +
  theme_grey(16) +
  theme(legend.title = element_blank())


##################################################
crimes_within <- function(r,long,lat){return(crime[distCosine(c(long,lat),crime[,c("Longitude","Latitude")])<=r,])} 
### pallette for circle fill color #6666cc  #3333cc

for (i  in 1:nrow(crime)){
  if(crime$LAW_CAT_CD[i]=="VIOLATION") crime$X[i]="yellow"
  if(crime$LAW_CAT_CD[i]=="MISDEMEANOR") crime$X[i]="orange"
  if(crime$LAW_CAT_CD[i]=="FELONY") crime$X[i]="red"
}

names(crime)[names(crime) == "X"] <- "color"