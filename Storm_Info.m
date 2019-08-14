%% Storm Information analysis
% Sai
data = textread('NABasin_ibtracs.csv','%s','delimiter',',');
d2d = reshape(data,[7 49649]);
strm_names = d2d(2,:);
strm_time1 = datetime(d2d(3,1:9253));
strm_time2 = datetime(d2d(3,9254:end));
strm_time = [strm_time1 strm_time2]; 


storm.name = 'IVAN';
storm.year = 2004;
lvec = logical(strm_time.Year == storm.year) & logical(strcmp(strm_names,storm.name));
storm.id = unique(d2d(1,lvec));
storm.name = unique(d2d(2,lvec));
storm.time = (strm_time(lvec));
storm.lat = d2d(4,lvec);
storm.lon = d2d(5,lvec);
storm.V = d2d(6,lvec);
storm.P = d2d(7,lvec);

% Mine
track   = 1621;  % 1621 for Ivan
time_track = ncread('Basin.NA.ibtracs_wmo.v03r10.nc', 'time_wmo');
% time_track = h_2_s(time_track);  % converting from days to seconds
time_track = time_track(:, track);
time_track = time_track(~isnan(time_track));
% time_track = rmmissing(time_track);
time_track = datetime(time_track*24*3600,'ConvertFrom','epochtime','Epoch','1858-11-17');


%% Specific Humidity datetime analysis

time_sh = ncread('shum.mon.mean.nc','time');
datetime(time_sh*3600,'convertFrom','epochtime','Epoch','1800-01-01');
date_SH = datetime(time_sh*3600,'convertFrom','epochtime','Epoch','1800-01-01');

%% Relative Humidity datetime analysis

        time_RH = ncread('rhum.mon.mean.nc', 'time'); % in hours
%         time_RH = h_2_s(time_RH);
        time_RH = datetime(time_RH*3600, 'ConvertFrom','epochtime','epoch','1800-01-01');

%% Sea Surface Temp datetime analysis
        time_SST = ncread('sst.mnmean.nc', 'time'); % in days
%         time_SST = d_2_s(time_SST_0); % convert form days to seconds
        time_SST = datetime(time_SST*24*3600, 'ConvertFrom','epochtime','epoch','1800-01-01');

%% Envr Shear datetime analysis

time_UV = ncread('uwnd.mon.mean.nc','time');
datetime(time_UV*3600,'convertFrom','epochtime','Epoch','1800-01-01');
date_uv = datetime(time_UV*3600,'convertFrom','epochtime','Epoch','1800-01-01');

