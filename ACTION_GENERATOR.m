function u = ACTION_GENERATOR(z)
global theta_v; global u_max;
global m; global l;global ts;

global Control_type; global Control_gain;

x = z(1:2)';

u = [0 -cos(x(1))]*NNGradientFire(theta_v,x)';

if min(Control_type == 'Normal')
    u = ts*u;
    u = u_max*tanh(u./(Control_gain*m*l^2*u_max));
else % B-bang control-type.
    if u > 0 u = u_max;
    elseif u == 0 u = 0;
    else u = - u_max;
    end    
end

end