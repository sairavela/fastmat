function SST = get_SST(x,y,t,SST_0,lat_SST,lon_SST,time_SST)
sst_td = datetime(time_SST,'convertfrom','epochtime','epoch','1800-1-1');
sst_tmy = sst_td.Year*12+sst_td.Month;
ibt_sst = datetime(t, 'ConvertFrom', 'epochtime', 'epoch','1858-11-17');
ibt_tmy = ibt_sst.Year*12+ibt_sst.Month+ibt_sst.Day./eomday(ibt_sst.Year,ibt_sst.Month);
% [~, storm_time_index] = min(abs(time_SST-t));
storm_time = max(sst_tmy(sst_tmy<ibt_tmy));
storm_time_index = find(sst_tmy==storm_time);
SST = interp2(lon_SST,lat_SST,SST_0(:,:,storm_time_index)',x,y);
% SST = interp2(lon_SST,lat_SST,SST_0(:,:,storm_time_index)',x,y);
% SST = interp2(double(lon_SST),double(lat_SST),SST_time_idx',SST_0,x,y,time_vec_idx);
end