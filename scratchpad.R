library(httr)
library(jsonlite)
#this will work once we figure out how to log in via R
for(pages in 0:9){
  start <- pages * 100 +1
  url <- paste("https://connect.garmin.com/proxy/activity-search-service-1.2/json/activities?start=",start,"&limit=100",sep='')
  print(paste("pages=",pages, start, url))
  rawData <- fromJSON(url)
  a1 <- cbind(activityId=rawData[[1,1]]$activity$activityId,activityDate=rawData[[1,1]]$activity$uploadDate$display)
  if(pages==0){
    a2 <- a1
  }  
  else{
    rbind(a2,a1)
  }
}

for(pages in 1:7){
  print(paste("pages=",pages))
  rawData <- fromJSON(paste('/Users/scoyote/Documents/Garmin/activities',pages,".json",sep=''))
  a1 <- cbind(activityId=rawData[[1,1]]$activity$activityId,activityDate=rawData[[1,1]]$activity$uploadDate$display)
  if(pages==1){
    a2 <- a1
  }  
  else{
    a2 <- rbind(a2,a1)
  }
}


rawData <- fromJSON('/Users/scoyote/Documents/Garmin/activities1.json')
a1 <- cbind(activityId=rawData[[1,1]]$activity$activityId,activityDate=rawData[[1,1]]$activity$uploadDate$display)
for(i in 1:length(a1[,1])){
  print(paste('url "https://connect.garmin.com/modern/activity/',a1[i,1],'#" -o "',a1[i,1],'.tcx"',sep=''))
  https://connect.garmin.com/modern/activity/1018482334#
}
