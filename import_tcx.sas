/********************************************************************************
 *  Generated by XML Mapper, 904300.0.0.20150204190000_v940m3
 ********************************************************************************/

/*
 *  Environment
 */
filename  activity 'C:\Data\Garmin\tcx\activity_948797879.tcx';
filename  SXLEMAP 'C:\Data\Garmin\tcx.map';
libname   activity xmlv2 xmlmap=SXLEMAP access=READONLY;

/*
 *  Catalog
 */

proc datasets lib=activity; run;

/*
 *  Contents
 */

proc contents data=activity.TrainingCenterDatabase varnum; run;
proc contents data=activity.Activities varnum; run;
proc contents data=activity.Activity varnum; run;
proc contents data=activity.Lap varnum; run;
proc contents data=activity.AverageHeartRateBpm varnum; run;
proc contents data=activity.MaximumHeartRateBpm varnum; run;
proc contents data=activity.Track varnum; run;
proc contents data=activity.Trackpoint varnum; run;
proc contents data=activity.Position varnum; run;
proc contents data=activity.HeartRateBpm varnum; run;
proc contents data=activity.Extensions varnum; run;
proc contents data=activity.LX varnum; run;
proc contents data=activity.Creator varnum; run;
proc contents data=activity.Version varnum; run;
proc contents data=activity.Author varnum; run;
proc contents data=activity.Build varnum; run;
proc contents data=activity.Version1 varnum; run;

/*
 *  Printing
 */

title 'Table TrainingCenterDatabase';
proc print data=activity.TrainingCenterDatabase(obs=10); run;
title;

title 'Table Activities';
proc print data=activity.Activities(obs=10); run;
title;

title 'Table Activity';
proc print data=activity.Activity(obs=10); run;
title;

title 'Table Lap';
proc print data=activity.Lap(obs=10); run;
title;

title 'Table AverageHeartRateBpm';
proc print data=activity.AverageHeartRateBpm(obs=10); run;
title;

title 'Table MaximumHeartRateBpm';
proc print data=activity.MaximumHeartRateBpm(obs=10); run;
title;

title 'Table Track';
proc print data=activity.Track(obs=10); run;
title;

title 'Table Trackpoint';
proc print data=activity.Trackpoint(obs=10); run;
title;

title 'Table Position';
proc print data=activity.Position(obs=10); run;
title;

title 'Table HeartRateBpm';
proc print data=activity.HeartRateBpm(obs=10); run;
title;

title 'Table Extensions';
proc print data=activity.Extensions(obs=10); run;
title;

title 'Table LX';
proc print data=activity.LX(obs=10); run;
title;

title 'Table Creator';
proc print data=activity.Creator(obs=10); run;
title;

title 'Table Version';
proc print data=activity.Version(obs=10); run;
title;

title 'Table Author';
proc print data=activity.Author(obs=10); run;
title;

title 'Table Build';
proc print data=activity.Build(obs=10); run;
title;

title 'Table Version1';
proc print data=activity.Version1(obs=10); run;
title;


/*
 *  Local Extraction
 */

DATA TrainingCenterDatabase; SET activity.TrainingCenterDatabase; run;
DATA Activities; SET activity.Activities; run;
DATA Activity; SET activity.Activity; run;
DATA Lap; SET activity.Lap; run;
DATA AverageHeartRateBpm; SET activity.AverageHeartRateBpm; run;
DATA MaximumHeartRateBpm; SET activity.MaximumHeartRateBpm; run;
DATA Track; SET activity.Track; run;
DATA Trackpoint; SET activity.Trackpoint; run;
DATA Position; SET activity.Position; run;
DATA HeartRateBpm; SET activity.HeartRateBpm; run;
DATA Extensions; SET activity.Extensions; run;
DATA LX; SET activity.LX; run;
DATA Creator; SET activity.Creator; run;
DATA Version; SET activity.Version; run;
DATA Author; SET activity.Author; run;
DATA Build; SET activity.Build; run;
DATA Version1; SET activity.Version1; run;

proc sql;
	create table TrackObs as
		select position.trackpoint_ordinal, latitudeDegrees, longitudeDegrees, time, altitudemeters, distancemeters, heartratebpm.value as heartratebpm
		from Position inner join trackpoint on position.trackpoint_ordinal = trackpoint.trackpoint_ordinal
			inner join heartratebpm on position.trackpoint_ordinal = heartratebpm.trackpoint_ordinal
		order by trackpoint_ordinal;
quit;


libname sam 'C:\Data\Garmin';
data sam.trackobs;
	set trackobs;
	by trackpoint_ordinal;
	distdelta = distancemeters - lag(distancemeters);
	timedelta = time - lag(time);
	speed_mph = (distdelta/timedelta)*2.23694;
	pace = (timedelta/60)/(distdelta*0.000621371);
/*	drop distdelta timedelta;*/
run;
data sam.trackobs;
	set sam.trackobs;
	if _n_ > 1 then do;
		if missing(speed_mph) then  speed_mph=lag(speed_mph);
		if missing(pace) then  speed_mph=lag(pace);
	end;
run;


data sam.trackobs_network;
	label	node1 = 'Source'
			node2 = 'Target'
			activity = "Activity"
			time1='StartTime'
			time2="EndTime"
			latitude1 = 'Start Latitude'
			latitude2 = 'End Latitude'
			Longitude1 = 'Start Longitude'
			Longitude2 = 'End Longitude'
			heartratebpm ='Heart Rate(BPM)'
			speed_mph = 'Speed(mph)'
			pace = 'Pace(min/mile)';
	set sam.trackobs;*(rename=(time=time1 latitudedegrees=latitude1 longitudedegrees=longitude1));
	activity = 'NYC Running';
	node2 = trackpoint_ordinal;
	latitude2=latitudeDEGREES;
	longitude2=LongitudeDEGREES;
	time2=time;	format time2 is8601DT19.;

	time1=lag(time);	format time1 is8601DT19.;
	node1 = lag(trackpoint_ordinal);
	latitude1=lag(latitudeDEGREES);
	longitude1= lag(longitudeDEGREES);

	if _n_ > 1 then do;
		if missing(speed_mph) then  speed_mph=lag(speed_mph);
		if missing(pace) then  speed_mph=lag(pace);
	end;
	if _n_ = 1 then delete;
	keep node1 node2 activity time1 time2 latitude1 latitude2 longitude1 longitude2 heartratebpm speed_mph pace;

run;
