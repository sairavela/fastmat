function a = get_alpha(z, t)
z = 0.01*G^(-0.4)*h_mix*u_t*Vp/V
a = 1 - 0.87*exp.^(-z)
%%%%%%%%%% not sure how to go about with V being in the z equation %%%%%%
end
