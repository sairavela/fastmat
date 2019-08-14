
% Functions to prevent conversion errors

%%%%% Temperature %%%%%
C_2_K = @(T_C) T_C + 273.15;            % Celcius to Kelvin
K_2_C = @(T_K) T_K -273.15;             % Kelvin to Celcius
%%%%% Speed %%%%%%%%%%%
kt_2_ms = @(v_kt) v_kt./1.944;          % kt to m/s
ms_2_kt = @(v_ms) v_ms.*1.944;          % m/s to kt
%%%%% Time %%%%%%%%%%%
d_2_s = @(t_d) t_d.*(24*60*60);         % day to seconds
h_2_s = @(t_h) t_h.*(60*60);            % hours to seconds
s_2_h = @(t_s) t_s./(60*60);            % seconds to hours
s_2_d = @(t_s) t_s./(24*60*60);         % seconds to days



