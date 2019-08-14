
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load all the variables from netcdf files
helpingAnonFxns;
% 
global RH SH_0 lat_RH lon_RH...
    time_RH SST_0 lat_SST lon_SST time_SST track time_track...
    wind_track lat_track lon_track lat_shr lon_shr time_shr sh;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\
% Hurricane Track Information 
track = 1621;
time_track = ncread('Basin.NA.ibtracs_wmo.v03r10.nc', 'time_wmo');
time_track = d_2_s(time_track);  % converting from days to seconds
time_track = time_track(:, track);
time_track = time_track(~isnan(time_track));
% time_vec = time_track(1):1200:time_track(end);
% time_vec_dt = datetime(time_vec,'convertfrom','epochtime','epoch','1858-11-17');
% time_vec_idx = time_vec_dt.Year*12+time_vec_dt.Month+...
%     time_vec_dt.Day./eomday(time_vec_dt.Year,time_vec_dt.Month);
wind_track = ncread('Basin.NA.ibtracs_wmo.v03r10.nc', 'wind_wmo');
wind_track = kt_2_ms(wind_track); % converting from knots to m/s
wind_track = wind_track(:,track);
wind_track = wind_track(~isnan(wind_track));
lat_track = ncread('Basin.NA.ibtracs_wmo.v03r10.nc', 'lat_wmo');
lat_track = lat_track(:,track);
lat_track = lat_track(~isnan(lat_track));
lon_track = ncread('Basin.NA.ibtracs_wmo.v03r10.nc', 'lon_wmo');
lon_track = lon_track(:,track);
lon_track = lon_track(~isnan(lon_track));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initial Conditions for ODE solver
t = time_track;
tspan = [t(1) t(end)];
% V0  = wind_track(1);  % in m/s
V0 = ms_2_kt(wind_track(1));
%m0 = 0.0835;
%m0  = 0.437;
%m0 = 0.35
m0 = nthroot((V0)^2/(1*(1-0.33-0.1)*(90)^2+(0.33+1*0.1)*(V0)^2),3);
disp('Set Up t and Initial Conditions')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % load up files for SSatH
        RH = ncread('rhum.mon.mean.nc', 'rhum'); % unitless
        SH_0 = ncread('shum.mon.mean.nc', 'shum'); % percent        
        lat_RH = ncread('rhum.mon.mean.nc', 'lat');
        lon_RH = ncread('rhum.mon.mean.nc', 'lon');
        time_RH = ncread('rhum.mon.mean.nc', 'time'); % in hours
        time_RH = h_2_s(time_RH);
        disp('Loaded Files for SSatH Calculation')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % load up files for EnvShr
        envshear_dir = 'C:\cygwin64\home\sdavi\envshear.nc'; % location at which datafile is located
        time_shr = double(ncread(envshear_dir,'time')); % convert int.32 time into double
        % time_shear = datetime(time_shr*3600, 'ConvertFrom', 'EpochTime', 'Epoch', '1900-01-01');
        lon_shr = ncread(envshear_dir, 'longitude');
        lat_shr = ncread(envshear_dir, 'latitude');
        load shear0904.mat;% variable sh
        disp('Loaded files for Environmental Shear Calcuation')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % load up Sea Surface Temperature
        SST_0 = ncread('sst.mnmean.nc', 'sst'); %Celcius
        SST_0 = C_2_K(SST_0); % convert from Celcius to Kelvin
        lat_SST = ncread('sst.mnmean.nc','lat');
        lon_SST = ncread('sst.mnmean.nc', 'lon');
        time_SST = ncread('sst.mnmean.nc', 'time'); % in days
        time_SST = d_2_s(time_SST); % convert form days to seconds
        disp('Loaded files for Sea Surface Temperature Calculation')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setting up the ODE solver
%  sol=ode45(@ode,t,[V0,m0]);
% f = deval(sol,t);
 [t_45, f_45] =ode45(@ode,tspan,[V0,m0]');
 % outputs for graphing
 [V_6hr] = interp1(t_45, f_45(:,1),t);
 [m_6hr] = interp1(t_45, f_45(:,2),t);
 [S_6hr] = interp1(t_45, f_45(:,:),t);

%% Plotting Results %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        figure(4)
        %subplot(1,2,1)
        plot(datetime(t,'ConvertFrom','epochtime','Epoch','1858-11-17'),ms_2_kt(V_6hr),'-r',...
            datetime(t,'ConvertFrom','epochtime','Epoch','1858-11-17'), ms_2_kt(wind_track),'-k', 'LineWidth',2)
        title('Circular Wind Speed (V)','FontSize', 28, 'FontName', 'Arial')
        legend('Intensity Simulator', 'Best Track Data', 'FontSize', 24)
        xlabel('Duration','FontWeight','bold','FontSize',24,'FontName','Arial');
        ylabel('Velocity (m/s)','FontWeight','bold','FontSize',24,'FontName','Arial');
%         figure(2)
% %         subplot(1,2,2)
%         set(gca,'YDir','Normal','FontName','Calibri','FontSize',20)
%         plot(datetime(t,'ConvertFrom','epochtime','Epoch','1858-11-17'),m_6hr,'-k')
%         title('Moisture (kg/kg)', 'FontSize', 26)
%         xlabel('Duration', 'FontSize',20); ylabel('kg/kg', 'FontSize', 20)
 %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % ODE solver
    function [df] =ode(t,f)
global RH SH_0 lat_RH lon_RH...
    time_RH SST_0 lat_SST lon_SST time_SST track time_track...
    wind_track lat_track lon_track lat_shr lon_shr time_shr sh;

    helpingAnonFxns;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Setting Universal Constants
        Cd = 0.0012;     % Cd: surface drag coefficient
        Ck = 0.0012;     % Ck: surface enthalpy change
        Lv = 2.23e6;     % latent heat of vaoporization
        Rd = 287.047;    % gas constant of dry air (J/kg*k)
        h  = 1400;       % boundary layer depth (m)
        to  = C_2_K(30); % To not T0
        % use time to calculate location of hurricane 
        x = get_x(t,time_track,lon_track)+360   % longitude 
        y = get_y(t,time_track,lat_track)   % latitude
        disp('Calculated Location of Hurricane')
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Calculating Parameters
%         S  = get_EnvShear(x,y,t,V_Wind,U_Wind, lat_UV, lon_UV, time_SST);
%         S = zeros(size(time_vec));
        S = get_envshr(x,y,t,sh,lat_shr,lon_shr, time_shr);
        disp('Obtained Environmental Shear')
        q  = get_SSatH(x,y,t,RH,SH_0,lat_RH,lon_RH,time_RH);
        disp('Obtained Surface Saturation Specific Humidity')
%         SST = zeros(size(time_vec));
        SST = get_SST(x,y,t,SST_0,lat_SST,lon_SST,time_SST);
        disp('Obtained Sea Surface Temperature')
        
        % kappa, alpha, gamma, epsilon (setting as constants for now)
        a  = 1;
        eps = 0.33;
        ka = 0.1;
        ba = get_beta(ka, eps);
        gamma = get_gamma(ka, eps, a);
        Vp = get_Vp(SST,to);            % potential intensity
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%         f(1) = V;
%         f(2) = m;

        df(1,1) = (1/2)*(Cd/h)*(a*ba*Vp.^2*f(2).^3 - (1-gamma*f(2).^3)*f(1).^2); % dv/dt
        df(2,1) = (1/2)*(Cd/h)*((1-f(2))*f(1) - 2.2*S*f(2));  % dm/dt
        
        
%         figure(2)
%         subplot(1,2,1)
%         plot(datetime(time_vec),ms_2_kt(Vp),'or',...
%             datetime(time_vec),ms_2_kt(f(1)),'^b',...
%             datetime(time_vec),S,'sg')
%         title('Velocity (kt)')
%         legend('Potential Intensity (kt)','Circular Wind Speed (kt)', 'Wind Shear')
%         hold on
%         drawnow
%         subplot(1,2,2)
%         plot(datetime(t,'ConvertFrom','epochtime','Epoch','1858-11-17'),f(2),'ok')
%         title('Moisture (kg/kg)')
%         hold on
%         drawnow
    end   
