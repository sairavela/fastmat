% checking is wind shear values are within the grid
V_Wind = ncread('vwnd.mon.mean.nc','vwnd');
U_Wind = ncread('uwnd.mon.mean.nc','uwnd');
lat_RH = ncread('rhum.mon.mean.nc', 'lat');
lon_RH = ncread('rhum.mon.mean.nc', 'lon');
time_RH = ncread('rhum.mon.mean.nc', 'time');
%% 
V_250 = V_Wind(:,:,9,:); % 250 mb of V winds
V_850 = V_Wind(:,:,3,:); % 850 mb of V winds
U_250 = U_Wind(:,:,9,:); % 250 mb of U winds
U_850 = U_Wind(:,:,3,:); % 850 mb of U Winds
S_0 = sqrt((U_250-U_850).^2+(V_250-V_850).^2); % Magnitude of wind shear

axesm('mercator','MapLonLimit',[240 300],'MapLatLimit',[0 35])
plotm(lat_RH,lon_RH)
% plotm(storm_lat, storm_lon,'color','k')