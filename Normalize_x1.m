function x_normalized = Normalize_x1(x)
% Normalization of x1 to [-pi, pi]...
if x(1) > pi
    x(1) = x(1) - 2*pi;
elseif x(1) < -pi
    x(1) = x(1) + 2*pi;
end
x_normalized = x;
end