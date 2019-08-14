function Vp = get_Vp(SST,to)
helpingAnonFxns;
A = 28.2; % (m/s)
B = 55.8; % (m/s)
C = 0.1813; % Thermal Expansion (0.1813/Celcius)
% bathy = load('bathymetry.mat');
% lon_b = linspace(-180, 180, 1440);
% lat_b = linspace(-90, 90, 721);
% 
Vp = (A + B*exp(C*(SST-to)))*1.45;


% Once the hurricane makes landfall, PI = 0
end