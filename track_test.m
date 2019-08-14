        track   = 1690;  % 1690 for Dolly
        time_track = ncread('Basin.NA.ibtracs_wmo.v03r10.nc', 'time_wmo');
        time_track = time_track(:, track);
        time_track = time_track(~isnan(time_track));
        wind_track = ncread('Basin.NA.ibtracs_wmo.v03r10.nc', 'wind_wmo');
        % get rid of NaNs for latitude and longitudes
        lat_track = ncread('Basin.NA.ibtracs_wmo.v03r10.nc', 'lat_wmo');
        lon_track = ncread('Basin.NA.ibtracs_wmo.v03r10.nc', 'lon_wmo');
        lat_track = lat_track(:,track);
        lat_track = lat_track(~isnan(lat_track));
        lon_track = lon_track(:,track);
        lon_track = lon_track(~isnan(lon_track));
        wind_track = wind_track(:,track);
        wind_track = wind_track(~isnan(wind_track));
        disp('Loaded TC Track and Removed NaNs')