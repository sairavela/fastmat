% in hours, so no need to convert
function q = get_SSatH(x,y,t,RH,SH_0,lat_RH,lon_RH,time_RH)
SH = SH_0(:,:,:,1:816); % all lat, all lon, all height, range from 1 to 816
q = (SH/1000)./(RH/100); % element-wise operator % / = mult. by inverse of second matrix 

[~, storm_time_index] = min(abs(time_RH-t));
q = interp2(lon_RH, lat_RH, q(:,:,storm_time_index)',x,y);
end 
% lat = ncread('rhum.mon.mean.nc','lat');
% lon = ncread('rhum.mon.mean.nc', 'lon');
% timeRH = ncread('rhum.mon.mean.nc','time');
% level = ncread('rhum.mon.mean.nc', 'level');
% figure 
% subplot(3,1,1) % plot on same figure with 3 rows and 1 column and number of columns
% pcolor(lon,lat,SH(:,:,1,816)'); shading interp % prime = transpose
% xlabel('longitude'); ylabel('latitude')
% title('Specific humidity')
% 
% subplot(3,1,2) % plot on same figure with 3 rows and 1 column and number of columns
% pcolor(lon,lat,RH(:,:,1,816)'); shading interp %prime = transpose
% xlabel('longitude'); ylabel('latitude')
% title('Relative humidity')
% 
% subplot(3,1,3) % plot on same figure with 3 rows and 1 column and number of columns
% pcolor(lon,lat,SSat_H(:,:,1,816)'); shading interp %prime = transpose
% xlabel('longitude'); ylabel('latitude')
% title('Saturation Specific humidity')
% 
% timeSH = ncread('shum.mon.mean.nc','time');
% 
% % for testing how timeRH and time SH are related
% figure
% plot(timeRH,'r.','Markers',15)
% hold on %allows to plot multiple plots in same figure
% plot(timeSH,'b.','Markers',10)
% legend('Time for RH','Time for SH')
% xlim([800 950])