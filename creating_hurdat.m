% Extract a hurdat file for SMS 
helpingAnonFxns;
track = 1621;
time_track = ncread('Basin.NA.ibtracs_wmo.v03r10.nc', 'time_wmo');
% time_track = d_2_s(time_track);  % converting from days to seconds
time_track = time_track(:, track);
time_track = time_track(~isnan(time_track));
time_datetm = datetime(time_track,'convertfrom','epochtime','epoch','1858-11-17');
wind_track = ncread('Basin.NA.ibtracs_wmo.v03r10.nc', 'wind_wmo');
% wind_track = kt_2_ms(wind_track); % converting from knots to m/s
wind_track = wind_track(:,track);
wind_track = wind_track(~isnan(wind_track));
lat_track = ncread('Basin.NA.ibtracs_wmo.v03r10.nc', 'lat_wmo');
lat_track = lat_track(:,track);
lat_track = lat_track(~isnan(lat_track));
lon_track = ncread('Basin.NA.ibtracs_wmo.v03r10.nc', 'lon_wmo');
lon_track = lon_track(:,track);
lon_track = lon_track(~isnan(lon_track));
mb_track = ncread('Basin.NA.ibtracs_wmo.v03r10.nc', 'pres_wmo');
mb_track = mb_track(:,track);
mb_track = mb_track(~isnan(mb_track));


TCS_hurdat_IVAN = [lat_track'; lon_track'; time_track'; V_6hr';...
    mb_track'];
% latitude, longitude, time offset (datetime), Circular Wind Speeds
% (output), minimum sea level pressure