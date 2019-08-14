
% ODE45
% for your equations, you could say P(1) is V and P(2) is m
% Start off with Hurricane Dolly (2008)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load all the variables from netcdf files
RH = ncread('rhum.mon.mean.nc', 'rhum');
lat_RH = ncread('rhum.mon.mean.nc', 'lat');
lon_RH = ncread('rhum.mon.mean.nc', 'lon');
time_RH = ncread('rhum.mon.mean.nc', 'time'); % in hours
disp('Loaded RH, SH, V-Wind, and U-Wind from netCDF')

track   = 1690;  % 1690 for Dolly
time_track_0 = ncread('Basin.NA.ibtracs_wmo.v03r10.nc', 'time_wmo');
time_track = time_track_0.*(24); % to convert from days to hours
wind_track = ncread('Basin.NA.ibtracs_wmo.v03r10.nc', 'wind_wmo');

disp('Loaded TC Track and Removed NaNs')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% time (dependent variable)
t = time_track(:,track);
% get rid of the NaNs
t = t(~isnan(t));

% declare initial conditions up here
% for wind, use the best-track value of the intensity at the first timestep
V0  = 1.944*wind_track(1);  % (1.944 m/s per knot) * (wind in knots)

% for m: value of 600 hPa RH multiplied by 1.2
m0  = 0.8;

disp('Set Up t and Initial Conditions')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% arguments to ode45:
% @ode: a matrix describing what the differential equations are (see below)
% [10,0.3]: initial conditions.  first is the initial value for V
%                                second is the initial value for m
 sol=ode45(@ode,t,[V0,m0]);
 
% return t and f
f = deval(sol,t);
 
% plot to check it's working
figure(1)
plot(t,f,'LineWidth',2)
set(gca,'FontName','Palatino','FontSize',15)
grid minor; grid on
xlabel('Time','Interpreter','LaTeX','FontSize',16)
ylabel('Amplitude','Interpreter','LaTeX','FontSize',16)
title('ode45 Solver for FAST','LaTeX','FontSize',16)
legend('$V$','$m$','Interpreter','LaTeX','FontSize',20)
text
xlim([0 tmax])
 
 plot(t,s(:,1))
    % ODE solver
    function [fast] = dsdt(t,s,S,Cd,h,a,b,Vp,ga)
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % load all the variables from netcdf files
        RH = ncread('rhum.mon.mean.nc', 'rhum');
        SH_0 = ncread('shum.mon.mean.nc', 'shum');
        V_Wind = ncread('vwnd.mon.mean.nc','vwnd');
        U_Wind = ncread('uwnd.mon.mean.nc','uwnd');
        lat_RH = ncread('rhum.mon.mean.nc', 'lat');
        lon_RH = ncread('rhum.mon.mean.nc', 'lon');
        time_RH = ncread('rhum.mon.mean.nc', 'time'); % in hours
        disp('Loaded RH, SH, V, and U')

        SST_0 = ncread('sst.mnmean.nc', 'sst');
        lat_SST = ncread('sst.mnmean.nc','lat');
        lon_SST = ncread('sst.mnmean.nc', 'lon');
        time_SST = ncread('sst.mnmean.nc', 'time'); % in days
        disp('Loaded SST')

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
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % constants
        Cd = 0.0012;     % Cd: surface drag coefficient
        Ck = 0.0012;     % Ck: surface enthalpy change
        Lv = 2.23e6;     % latent heat of vaoporization
        Rd = 287.047;    % gas constant of dry air (J/kg*k)
        h  = 1400;       % boundary layer depth (m)
        
        % use time to calculate location of hurricane 
        x = get_x(t,time_track,lon_track);   % longitude 
        y = get_y(t,time_track,lat_track);   % latitude
        disp('Calculated Location of Hurricane')
        
        % use time and location to calculate environmental fields
        % sst, saturation specific humidity, outflow temperature, wind
        % shear
        
%         S   = get_EnvShear(x,y,t,V_Wind,U_Wind, lat_RH, lon_RH,time_RH);
%         disp('Obtained Environmental Shear')
%         q   = get_SSatH(x,y,t, RH, SH_0, lat_RH, lon_RH, time_RH);
%         disp('Obtained Surface Saturation Specific Humidity')
%         SST = get_SST(x,y,t,SST_0,lat_SST,lon_SST,time_SST);
%         disp('Obtained Sea Surface Temperature')
%         to  = 30+273.15;
        S = 1;
        disp('Obtained Environmental Shear')
        q = 1;
        disp('Obtained Surface Saturation Specific Humidity')
        SST = 30;
        disp('Obtained Sea Surface Temperature')
        to = 30;
        disp('Obtained Outflow Temperature')
        % stuff you need to calculate to calculate other stuff
        % kappa, alpha, gamma, epsilon
        a  = 1;                         % alpha (ocean interaction parameter)
%         eps = get_epsilon(SST,to);    % epsilon
%         ka = get_ka(eps,q,SST);       % kappa
%         b  = get_beta(ka,eps);        % beta 
%         ga = get_gamma(ka,eps,a);     % gamma
        eps = 0.33;
        ka = 0.1;
        b = 1- eps - ka;
        ga = eps + a*ka;
        % stuff you need to calculate
        Vp = get_Vp(SST,to);            % potential intensity
        [t,f] = ode45(@(t,f)dfdt(t,s,S,CD,h,a,b,Vp,g),[t_start t_end],s0)
        f(1) = V;
        f(2) = m;
        % df(1)=(f(1))^2 - f(1)*f(2);
        % df(2)=2*f(1)*f(2) - (f(2))^2;
        fast(2,1) = (1/2)*(Cd/h)*(a*b*Vp^2*f(2).^3 - (1-ga*f(2).^3)*f(1).^2); % dv/dt
        fast(1,2) = (1/2)*(Cd/h)*((1-f(2))*f(1) - 2.2*S*f(2));  % dm/dt
    end   
