helpingAnonFxns;
track = 1621;
time_track = ncread('Basin.NA.ibtracs_wmo.v03r10.nc', 'time_wmo');
snames = ncread('Basin.NA.ibtracs_wmo.v03r10.nc', 'name');
time_track = d_2_s(time_track);  % converting from days to seconds
time_track = time_track(:, track);
time_track = time_track(~isnan(time_track));
time_vec = time_track(1):1200:time_track(end);
time_vec_dt = datetime(time_vec,'convertfrom','epochtime','epoch','1858-11-17');
time_vec_idx = time_vec_dt.Year*12+time_vec_dt.Month+time_vec_dt.Day./eomday(time_vec_dt.Year,time_vec_dt.Month);
lat_track = ncread('Basin.NA.ibtracs_wmo.v03r10.nc', 'lat_wmo');
lat_track = lat_track(:,track);
lat_track = lat_track(~isnan(lat_track));
lon_track = ncread('Basin.NA.ibtracs_wmo.v03r10.nc', 'lon_wmo');
lon_track = lon_track(:,track);
lon_track = lon_track(~isnan(lon_track));
SST_0 = ncread('sst.mnmean.nc', 'sst'); %Celcius
SST_0 = C_2_K(SST_0); % convert from Celcius to Kelvin
lat_SST = ncread('sst.mnmean.nc','lat');
lon_SST = ncread('sst.mnmean.nc', 'lon');
time_SST = ncread('sst.mnmean.nc', 'time'); % in days
time_SST = d_2_s(time_SST); % convert form days to seconds
SST_dt = datetime(time_SST,'convertfrom','epochtime','epoch','1800-1-1');
SST_time_idx = SST_dt.Year*12+SST_dt.Month;
        envshear_dir = 'C:\cygwin64\home\sdavi\envshear.nc'; % location at which datafile is located
        time_shr = double(ncread(envshear_dir,'time')); % convert int.32 time into double
        lon_shr = ncread(envshear_dir, 'longitude');
        lat_shr = ncread(envshear_dir, 'latitude');
load shear0904.mat;
RH = ncread('rhum.mon.mean.nc', 'rhum'); % unitless
SH_0 = ncread('shum.mon.mean.nc', 'shum'); % percent        
lat_RH = ncread('rhum.mon.mean.nc', 'lat');
lon_RH = ncread('rhum.mon.mean.nc', 'lon');
time_RH = ncread('rhum.mon.mean.nc', 'time'); % in hours
SH = SH_0(:,:,:,1:816); % all lat, all lon, all height, range from 1 to 816
q = (SH/1000)./(RH/100);
% SSatH_dt = datetime(time_SST,'convertfrom','epochtime','epoch','1800-1-1');
% SSatH_time_idx = SSatH_dt.Year*12+SSatH_dt.Month;
S = zeros(size(time_vec));
SST = zeros(size(time_vec));
% SSatH = zeros(size(time_vec));
x =  interp1(time_track,lon_track,time_vec)+360; %longitude
y =  interp1(time_track,lat_track,time_vec); % latitude
S = interpn(double(lon_shr),double(lat_shr),double(1:30),sh,x,y,time_vec_dt.Day);
SST = interpn(double(lon_SST),double(lat_SST),SST_time_idx,SST_0,x,y,time_vec_idx);
% SSatH = interpn(double(lon_RH), double(lat_RH),SSatH_time_idx,q,x,y,time_vec_idx);
to  = C_2_K(30);
Vp = get_Vp(SST,to);
%%
subplot(221); % Environmental Wind Shear
plot(time_vec_dt,ms_2_kt(S),'LineWidth',2);
title('Environmental Wind Shear','FontSize',24);
% xlabel('Date-Time','FontSize',12);
ylabel('knots','FontSize',20);
xlabel('Date-Time','FontSize',20);
% grid on
subplot(222); % Sea Surface Temperature
plot(time_vec_dt,SST,'LineWidth',2);
title('Sea Surface Temperature','FontSize',24);
% xlabel('Date-Time','FontSize',12);
ylabel('Degrees Kelvin','FontSize',20);
xlabel('Date-Time','FontSize',20);
% grid on
subplot(224); % Potential Intensity
plot(time_vec_dt,ms_2_kt(Vp),'LineWidth',2);
title('Potential Intensity','FontSize',24);
% xlabel('Date-Time','FontSize',12);
ylabel('knots','FontSize',20);
xlabel('Date-Time','FontSize',20);
% grid on
subplot(223); % Moisture
plot(datetime(t,'ConvertFrom','epochtime','Epoch','1858-11-17'),m_6hr,'LineWidth',2);
title('Moisture','FontSize',24);
xlabel('Date-Time','FontSize',20);
ylabel('kg/kg','FontSize',20);
% grid on