function Plot3DPolicy(filename)
% Draw the 3D policy graphs of Fig. 2 in the simulation presented in
%
% "Jaeyoung Lee and Richard S. Sutton (2019) Policy Iterations for 
% Reinforcement Learning Problems in Continuous Time and Space -- 
% Fundamental Theory and Methods, under the review in Automatica."
%
% from the data obtained by running Main.m.
% 
% Arguments:
%   - filename: the data filename in the folder '.\data\'
%
%
% Examples: to reproduce the value-function-parts in Fig. 2 in the manuscript, 
%
% - Fig 2(c): Plot3DPolicy('DPI_Con_Normal')
% - Fig 2(d): Plot3DPolicy('IPI_Con_Normal')
% - Fig 2(g): Plot3DPolicy('DPI_Opt_Normal')
% - Fig 2(h): Plot3DPolicy('IPI_Con_B-bang')
% - Fig 2(k): Plot3DPolicy('DPI_Bin_B-bang')
% - Fig 2(l): Plot3DPolicy('IPI_Bin_B-bang')
% 
% The corresponding data files must be stored in the folder .\data\ a priori 
% (see and run Main.m to generate the data).
%
%
% Written by Jaeyoung Lee.
%

load(['.\data\', filename])
GridN1 = 200;
GridN2 = 200; 

pre_x1 = [-x1_bound:x1_bound/(GridN1-1):x1_bound]'; % the grid points in x1
pre_x2 = [-x2_bound:x2_bound/(GridN2-1):x2_bound]'; % the grid points in x2

l1 = length(pre_x1);
l2 = length(pre_x2);

figure
[x1, x2] = meshgrid(pre_x1,pre_x2);
z = zeros(l1,l2);

for i = 1:l1
    for j = 1:l2
        y1 = x1(i,j);
        y2 = x2(i,j);
        z(i,j) = ACTION_GENERATOR([y1;y2]);
    end
end

% 3D plotting the obtained value function
surf(x1,x2,z,'EdgeColor','none','LineStyle','none','FaceLighting','phong');
% Using surf instead of mesh(x1,x2,z), which causes black-out for large GridN

xlim([-pi,pi]);
colorbar('southoutside')
set(gcf,'NumberTitle','off') 

xt = [-pi,0,pi];
yt = [-6,0,6];
set(gca,'XTick',xt, 'YTick',yt,'XTickLabel','')
text(xt,-6*ones(size(xt)),{'-\pi','0','\pi'}, 'horizontal','center','vertical','top')
title(['The policy $\hat \pi_i$ ', sprintf('for $i = %2d$', nPI)], 'Interpreter', 'latex');
view(0,90) % make the figure top-viewed.
end
