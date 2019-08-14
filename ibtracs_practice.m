lat = ncread('Basin.NA.ibtracs_wmo.v03r10.nc', 'lat_wmo');
lon = ncread('Basin.NA.ibtracs_wmo.v03r10.nc', 'lon_wmo');
time = ncread('Basin.NA.ibtracs_wmo.v03r10.nc', 'time_wmo');
wind = ncread('Basin.NA.ibtracs_wmo.v03r10.nc', 'wind_wmo');

%% plot to see where there are nonzero entries
n = 331;

% track number 1690 is hurricane dolly
figure(1)
pcolor(wind(:,:)'); shading interp; set(gca,'YDir','Normal')
colormap(flipud(summer)); colorbar
ylabel('Track Number (size 1825)'); xlabel('Time (size 137)')
title('Max Sustained Wind Speed as Function of Time (kts)')

%%
% now 2D arrays, now pick out one particular storm 
track_number = 1690; % last track with any data

storm_lat = lat(:,track_number); % location at track number
storm_lon = lon(:,track_number); % location at track number
storm_time = time(:,track_number); % time at track number
storm_wind = wind(:,track_number); % wind at track number

figure(2)
subplot(131)
plot(storm_time,storm_lon)
title('longitude')

subplot(132)
plot(storm_time,storm_lat)
title('latitude')

subplot(133)
plot(storm_time,storm_wind)
title('intensity')

figure(3)
plot(storm_lon, storm_lat)
% hold on
% wm = worldmap('NA');
% load coastlines
% plotm(coastlat,coastlon)

plot(storm_lon, storm_lat)
