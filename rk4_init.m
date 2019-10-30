function [] = rk4_init(ts)
global rk4_c; global rk4_ts;
rk4_c = [1; 2; 2; 1]./6;
rk4_ts = ts;
end % For initialization of rk4 module...