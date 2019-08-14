function S = get_EnvShear(x,y,t,V_Wind,U_Wind, lat_UV, lon_UV, time_UV)
V_250 = V_Wind(:,:,9,:); % 250 mb of V winds
V_850 = V_Wind(:,:,3,:); % 850 mb of V winds
U_250 = U_Wind(:,:,9,:); % 250 mb of U winds
U_850 = U_Wind(:,:,3,:); % 850 mb of U Winds
S_0 = 0.3*(sqrt((U_250-U_850).^2+(V_250-V_850).^2)); % Magnitude of wind shear 

[~, storm_time_index] = min(abs(time_UV-t));
% [lati,loni] = meshgrid(lat_UV,lon_UV);
S = interp2(lon_UV, lat_UV, S_0(:,:,storm_time_index)',x,y);
end 