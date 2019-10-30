function z_dot = CLOSED_LOOP_SYS(z, u, opt)
global m; global l; global g; global mu;
global gamma;
z_dot = zeros(3,1);

x1 = z(1);
x2 = z(2);

z_dot(1) = x2;
z_dot(2) = -mu*x2 + m*g*l*sin(x1) - cos(x1)*u;
z_dot(2) = z_dot(2)/m/(l^2);
z_dot(3) = x2; % x3 is the copy of x1 without normalization to [-pi,pi].

 if exist('opt','var')
    if length(opt) == 6
        if min(opt == 'reward')
            z_dot = [z_dot ; 0]; % Add one variable to z_dot...
            z_dot(4) = R(z(1:2),u) + log(gamma)*z(4);
        end
    end
 end
 
end