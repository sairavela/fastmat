function y = get_y(t,time_track,lat_track) % latitude 

% find index corresponding to the time I passed in
%[~, time_index] = min(abs(time_track-t));

% return the latitude with the same index
%y = lat_track(time_index);

y = interp1(time_track,lat_track,t);
% if needed, interpolate
% time_low = max(time(time < t));  ind_low = find(time==time_low);
% time_high = min(time(time > t)); ind_high = find(time==time_high);
%
% time_step = time(ind_high) - time(ind_low);
% weight_low = (time_high - t) / time_step;
% weight_high = (t - t_low) / time_step;
%
% y = weight_low*lat(ind_low) + weight_high*lat(ind_high);


end