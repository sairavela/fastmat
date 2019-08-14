envshear_dir = 'C:\cygwin64\home\sdavi\envshear.nc';
envshr_lat = ncread(envshear_dir,'latitude');
envshr_lon = ncread(envshear_dir, 'longitude');
uwnd = ncread(envshear_dir, 'u');
envshr_time = ncread(envshear_dir, 'time');
ncdisp(envshear_dir)
envshr_time1 = datetime(uint64(envshr_time)*3600, 'ConvertFrom', 'EpochTime', 'Epoch', '1900-01-01');
whos
envshr_time1.Day
(envshr_time1.Day==1)
uwnd(:,:,:,(envshr_time1.Day==1))
uwnd(:,:,:,(envshr_time1.Day==2))
u1 = mean(uwnd(:,:,:,(envshr_time1.Day==1)))
size(u1)
u1 = mean(uwnd(:,:,:,(envshr_time1.Day==1)),4)
u1 = mean(uwnd(:,:,:,(envshr_time1.Day==1)),4);
size(u1)
% forloop that calculates the daily mean of u-winds 
for i = 1:30
ubar(:,:,:,i) = mean(uwnd(:,:,:,(envshr_time1.Day==i)),4);
end
clear uwnd;
ucompsh = squeeze((ubar(:,:,1,:)-ubar(:,:,2,:)).^2);
whos
clear ubar
vwnd = ncread(envshear_dir, 'v');
for i = 1:30
vbar(:,:,:,i) = mean(vwnd(:,:,:,(envshr_time1.Day==i)),4);
end
vcompsh = squeeze((vbar(:,:,1,:)-vbar(:,:,2,:)).^2);
clear vbar;
clear vwnd;
whos
sh=sqrt(ucompsh+vcompsh);
save shear0904 sh;