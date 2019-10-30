function DrawTrjGraph(filename, opt, draw_all)
% Draw the trajectories in the graphs of Fig. 1 in the simulation presented in
%
% "Jaeyoung Lee and Richard S. Sutton (2019) Policy Iterations for 
% Reinforcement Learning Problems in Continuous Time and Space -- 
% Fundamental Theory and Methods, under the review in Automatica."
%
% from the data obtained by running Main.m.
% 
% Arguments:
%   - filename: the data filename in the folder '.\data\'
%   - opt: a string of the drawing option. Should be 'Type_1' (for Case 1),
%             'Type_2' (for Cases 2 and 3), and 'Type_3' (for Case 4).
%   - draw_all: a boolean variable. When true, draw all the intermediate
%                     trajectories during the iterations, with the yellow lines.
%
% Examples: to reproduce Fig. 1 in the manuscript, 
%
% - Fig 1(a): DrawTrjGraph('DPI_Con_Normal', 'Type_1', true)
% - Fig 1(b): DrawTrjGraph('DPI_Opt_Normal', 'Type_2', true)
% - Fig 1(c): DrawTrjGraph('IPI_Con_Normal', 'Type_1', true)
% - Fig 1(d): DrawTrjGraph('IPI_Con_B-bang', 'Type_2', true)
% - Fig 1(e): DrawTrjGraph('DPI_Bin_B-bang', 'Type_3', true)
% - Fig 1(f): DrawTrjGraph('IPI_Bin_B-bang', 'Type_3', true)
% 
% Note:
%
%   - For a fast running, one can replace the last param (true) to false; 
%      in this case, the yellow lines (intermediate trjs.) are omitted in
%      the figure.
% 
%   - The corresponding data files must be stored in the folder .\data\ a priori
%      (see and run Main.m to generate the data).
%
%   - Fig. 1 in the manuscript is given after post-processing with fixPSlinestyle
%      library (github.com/djoshea/matlab-utils/tree/master/libs/fixPSlinestyle).
%
%
% Written by Jaeyoung Lee.
%

load(['.\data\', filename]);

if strcmp(opt, 'Type_2')
    iIndex = [1, 2, nPI] + 1;
    iIndex_out = (3 : nPI-1) + 1;
elseif strcmp(opt, 'Type_1') || strcmp(opt, 'Type_3')
    iIndex = [1, 2, 3, nPI] + 1;
    iIndex_out = (4 : nPI-1) + 1;
else
    disp('opt must be Type_1, Type_2, or Type_3.')
end  % end if

% Simulation for the obtained final policy starts...
figure
hold on

ts = 0.01;
t_f = 10;
t_f_iter = t_f/ts;
t_line = 0:ts:t_f;
rk4_init(ts);

X = zeros(4,t_f_iter+1);
u = zeros(2,t_f_iter+1);

init_bias = 0.00;

% Auxilary drawing for legend...
disp('Preparing for graph drawing...')
legends = [];
for iPI = iIndex
    theta_v = theta_v_trj(:, iPI);
    X(:,1) = [(1-init_bias)*pi 0 (1-init_bias)*pi 0]';
    
    for k = 1:t_f_iter
        u(:,k) = ACTION_GENERATOR(X(:,k));
        X(:,k+1) = rk4_closed(X(:,k), 'reward');
        if abs(X(1,k+1)) > pi
            X(:,k+1) = Normalize_x1(X(:,k+1));
        end
    end
    u(k+1) = ACTION_GENERATOR(X(:,k+1));
    legends = [legends ; ['{\it i}', sprintf(' = %2d', iPI - 1)]];
    plot(t_line, X(3,:), GetMarker4TrjGraph(iPI, iIndex, opt), 'LineWidth', 1.5);
end

hl = legend(legends);
set(hl, 'Interpreter', 'latex', 'FontName', 'Times New Roman');

if draw_all
    disp('Draw all the intermediate trajectories with yellow lines...')
    for iPI = iIndex_out
        theta_v = theta_v_trj(:,iPI);
        X(:,1) = [(1-init_bias)*pi 0 (1-init_bias)*pi 0]';
        
        for k = 1:t_f_iter
            u(:,k) = ACTION_GENERATOR(X(:,k));
            X(:,k+1) = rk4_closed(X(:,k), 'reward');
            if abs(X(1,k+1)) > pi
                X(:,k+1) = Normalize_x1(X(:,k+1));
            end
        end
        u(k+1) = ACTION_GENERATOR(X(:,k+1));
        plot(t_line, X(3,:), 'y', 'LineWidth', 1.5);
        disp(['the cummulative reward for the ', num2ordinal(iPI-1),' policy is ', num2str(X(4,t_f_iter))]);
    end % end for
end % end if

disp('Draw the main trajectories...')
for iPI = iIndex
    theta_v = theta_v_trj(:,iPI);
    X(:,1) = [(1-init_bias)*pi 0 (1-init_bias)*pi 0]';
    
    for k = 1:t_f_iter
        u(:,k) = ACTION_GENERATOR(X(:,k));
        X(:,k+1) = rk4_closed(X(:,k), 'reward');
        if abs(X(1,k+1)) > pi
            X(:,k+1) = Normalize_x1(X(:,k+1));
        end
    end
    u(k+1) = ACTION_GENERATOR(X(:,k+1));
    str = GetMarker4TrjGraph(iPI, iIndex, opt);
    plot(t_line, X(3,:), str, 'LineWidth', 1.5);
    disp(['the cummulative reward for the ', num2ordinal(iPI-1),' policy is ', num2str(X(4,t_f_iter))]);
end

hold off

xt = [0,5,10];
yt = [0,pi,2*pi];
set(gca,'XTick',xt, 'YTick',yt,'XTickLabel','','YTickLabel','')
text(-0.1*ones(size(yt)),yt,{'0','\pi','2\pi'},'horizontal','right')
text(xt,-0.15*ones(size(xt)),{' t=0','5','10'}, ...
           'horizontal','center','vertical','top')
xlim([0,10])
ylim([-0.1,2*pi+0.1])

set(gcf, 'Position', [100, 100, 500, 200])

end % end function