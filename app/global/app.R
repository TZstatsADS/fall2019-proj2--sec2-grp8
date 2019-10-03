
#Statistics Analysis Global Enviroment 


#Loadinbg the required data:

#activities <- read.csv("/Users/lihao/Documents/GitHub/fall2019-proj2--sec2-grp8/app/www/data/activities_processed.csv")
#school <- read.csv("/Users/lihao/Documents/GitHub/fall2019-proj2--sec2-grp8/app/www/data/school.csv")
#crime <- read.csv("/Users/lihao/Documents/GitHub/fall2019-proj2--sec2-grp8/app/www/data/teen_data.csv")



#Pie chart statistics of crime:
#library(googleVis)
#library(dplyr)
#library(data.table)


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

