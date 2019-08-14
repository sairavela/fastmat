function x = get_x(t,time_track,lon_track) % longitude

% find index corresponding to time I passed it in
%[~, time_index] = min(abs(time_track-t));

% return longitude for this time index
%x = lon_track(time_index);

x = interp1(time_track,lon_track,t);
end