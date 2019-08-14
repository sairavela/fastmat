function S = get_envshr(x,y,t,sh,lat_shr,lon_shr, time_shr)
ibt_shr = t;
ibt_shr = datetime(t, 'ConvertFrom', 'epochtime', 'epoch','1858-11-17');
t_day_shr = ibt_shr.Day;
time_shear = datetime(time_shr*3600, 'ConvertFrom', 'EpochTime', 'Epoch', '1900-01-01');
env_day_shr = time_shear.Day;
% t_day_shr = time_vec_dt.Day;
% S = interpn(double(lon_shr),double(lat_shr),double(1:30),sh,x,y,t_day_shr);

S = interp2(lon_shr,lat_shr,sh(:,:,t_day_shr)',x,y);
end