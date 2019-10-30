function plot_discrete_time_gamma(ts)
%
% A Code for Plotting the discount factor in discre time  
% for given the sampling time ts
%
% The code is not relevant to the main one, 
% but used only for seeing the discount factors in discrete time.
%
% Written by Jaeyoung Lee.
%
gamma = 0.001:0.001:1;
gts = gamma.^ts;
plot(gamma, gts);