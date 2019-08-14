function [SN, Track_Number] = get_SN(name,year)
% INPUT
% name : storm name as a string
% year : storm year as a double

serialnumber = ncread('Basin.NA.ibtracs_wmo.v03r10.nc','storm_sn');
stormname = ncread('Basin.NA.ibtracs_wmo.v03r10.nc','name');
stormyear = ncread('Basin.NA.ibtracs_wmo.v03r10.nc','time_wmo');

possible_cols = [];
for ii = 1:size(stormname,2) % fist number the year starts in
    if strcmp(stormname(1,ii),'E') % first letter of TC name
        if strcmp(stormname(1:length(name),ii)',name)
            possible_cols = [possible_cols, ii];
        end
    end
end


for jj = 1:length(possible_cols)
    t_since_01010000 = datetime(stormyear(:,possible_cols(jj))','ConvertFrom','datenum');
    test_year = t_since_01010000.Year+1858+1; % +1 seems to work but not 100% positive why its needed
    if test_year(1)==year
        actual_col = possible_cols(jj);
        break
    end
end

SN = serialnumber(:,actual_col)';
Track_Number = actual_col;
