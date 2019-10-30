function r = R(x,u)
    global Reward_type;
    if strcmp(Reward_type, 'Opt')
        r = OptimalControlR(x,u);
    elseif strcmp(Reward_type, 'Con')
        r = ContinuousR(x,u);
    elseif strcmp(Reward_type, 'Bin')
        r = BinaryR(x,u);
    else error('Reward_type should be Con, Bin, or Opt');
    end
end


function r = OptimalControlR(x,u)
global Control_type;

alpha = 0.01;
r = -x(1)^2 - alpha*x(2)^2;

if strcmp(Control_type, 'Normal')
    r = r - InputCost(u);
end

end


function r = ContinuousR(x,u)
global Control_type;

r = cos(x(1));

if strcmp(Control_type, 'Normal')
    r = r - InputCost(u);
end

end


function r = BinaryR(x,u)
global Control_type; 

if abs(x(1)) <= pi/6 && abs(x(2)) <= 0.5
    r = 1; 
else
    r = 0;
end

if strcmp(Control_type, 'Normal')
    r = r - InputCost(u);
end

end


function y = InputCost(u)
global u_max;global Control_gain;
u_nor = u/u_max;
temp1 = 1+u_nor;
temp2 = 1-u_nor;
y = Control_gain*(u_max^2)*log((temp1^temp1)*(temp2^temp2))/2;
end
