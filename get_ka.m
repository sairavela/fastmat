function ka = get_ka(eps,q,SST)
Cd = 0.0012;     % Cd: surface drag coefficient
Ck = 0.0012;    % Ck: surface enthalpy change
Lv = 2.23e6;   % latent heat of vaoporization
Rd = 287.047;  % gas constant of dry air (J/kg*k)

% formula that calc. kappa
ka = (eps/2)*(Ck/Cd)*((Lv*q)/(Rd*SST));
end