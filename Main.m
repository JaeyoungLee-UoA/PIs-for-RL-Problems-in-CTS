function Main(method, reward_type, control_type, NM, nPI)
% The main function for reprocuding the data in the simulation presented in
%
% "Jaeyoung Lee and Richard S. Sutton (2019) Policy Iterations for 
% Reinforcement Learning Problems in Continuous Time and Space -- 
% Fundamental Theory and Methods, under the review in Automatica."
% 
% Arguments:
%   - method: the PI method to be used. Should be a string of either 'DPI' or 'IPI'
%
%   - reward_type: the reward type to be used. Should be a string of 
%                            'Con' (continuous), 'Bin' (binary), or 'Opt' (optimal control)
%
%   - control_type: the type of the control part in the reward. Should be a string 
%                           of 'Normal' or 'B-bang'. When control-type = 'B-bang', 
%                           the bang-bang-type reward is given, i.e., the control cost
%                           is not included in the reward calculation.
%
%   - NM: a 2D-vector of the number of grid points {x_k} corresponding to N 
%            (along the x_1-axis) and M (along the x_2-axis) in the manuscript. 
%            NM(1) corresponds to N and NM(2) to M.
%
%   - nPI: the number of iterations. To reproduce the results in the manuscript,
%             nPI should be 50.
%
% Examples: to reproduce the data corresponding to the simulations in the
% manuscript, 
%
% 1) Case 1: Concave Hamiltonian with Bounded Reward (Section 7.1)
%       - DPI: Main('DPI', 'Con', 'Normal', [20, 21], 50)
%       - IPI: Main('IPI', 'Con', 'Normal', [20, 21], 50)
%
% 2) Case 2: Optimal Control (Section 7.2)
%       - DPI: Main('DPI', 'Opt', 'Normal', [20, 21], 50)
%       - IPI: Main('IPI', 'Opt', 'Normal', [20, 21], 50)
%
% 3) Case 3: Bang-bang Control (Section 7.3)
%       - DPI: Main('DPI', 'Con', 'B-bang', [20, 21], 50)
%       - IPI: Main('IPI', 'Con', 'B-bang', [20, 21], 50)
%
% 3) Case 4: Bang-bang Control with Binary Reward (Section 7.4)
%       - DPI: Main('DPI', 'Bin', 'B-bang', [20, 20], 50)
%       - IPI: Main('IPI', 'Bin', 'B-bang', [20, 21], 50)
%
% Once running the code, the data is stored in the folder .\data\
%
% Written by Jaeyoung Lee.
%

global Method; Method = method; % DPI or IPI
global Reward_type; Reward_type = reward_type; % Con (continuous), Bin (binary), or Opt (optimal control)
global Control_type; Control_type = control_type; % Normal or B-bang
global Control_gain; Control_gain = 0.01; % This variable is used only when Control_type = 'Normal'

if ~(min(Method == 'DPI') || min(Method == 'IPI'))
    error('Method should be DPI or IPI.')
end

if ~(min(Reward_type == 'Con') || min(Reward_type == 'Bin') || min(Reward_type == 'Opt'))
    error('Reward_type should be Con, Bin, or Opt.')
end

global N1; global N2;
N1 = 11; % # of points in x1 for RBFN
N2 = 11; % # of points in x2 for RBFN

global x1_bound; global x2_bound;
x1_bound = pi; % learning region:    -pi <= x1 <= pi
x2_bound = 6;  % learning region:     -6 <= x2 <= 6

global RBFN_centers1; global RBFN_centers2;  % Center points of the RBFs
RBFN_centers1 = [-x1_bound:2*x1_bound/(N1-1):x1_bound]'; % center points of RBFs in x1
RBFN_centers2 = [-x2_bound:2*x2_bound/(N2-1):x2_bound]'; % center points of RBFs in x2

global m; global l; global g; global mu; % Pendulum parameters...
m = 1;l = 1;g = 9.8;mu = 0.01;

global sig1; global sig2; % parameters in RBFs
sig1 = 1;
sig2 = 0.5;

global theta_v; % the weight vector of RBFVN
theta_v = zeros(N1*N2,1);
theta_v_trj = theta_v;

global u_max; u_max = 5; % saturation input...

global ts; ts = 0.01;           % Time-step in the Runge-Kutta method
rk4_init(ts);                        % Initialization for the use of Runge-Kutta 4 method

global gamma; gamma = 0.1; % Set-up the discount factor (continuous reward case)
gamma_d = gamma^ts;

GridN1 = NM(1);  % N in the manuscript
GridN2 = NM(2);  % M in the manuscript

x1_grids = [-x1_bound:2*x1_bound/(GridN1-1):x1_bound]'; % the grid points in x1
x2_grids = [-x2_bound:2*x2_bound/(GridN2-1):x2_bound]'; % the grid points in x2

for iPI=1:nPI
    
    C = zeros(GridN1*GridN2,N1*N2);
    b = zeros(GridN1*GridN2,1);
    
    counter = 0;
    for i = 1:GridN1
        for j = 1:GridN2
            counter = counter+1;
            x0 = [x1_grids(i) ; x2_grids(j) ; x1_grids(i)];
            x = x0;
            u = ACTION_GENERATOR(x);
            
            if min(Method == 'DPI')
                Reward = R(x,u);
                x_dot = CLOSED_LOOP_SYS(x, u);
                C(counter,:) = -(ts*NNHiddenGradientFire(x)*x_dot(1:2) + log(gamma^ts)*NNHiddenFire(x))';
                b(counter) = Reward;
            else
                Reward = R(x,u);
                [x, u] = rk4_closed(x, 'normal');
                x = Normalize_x1(x);
                
                C(GridN1*GridN2+counter,:) = (NNHiddenFire(x0) - gamma_d*NNHiddenFire(x))';
                b(GridN1*GridN2+counter) = Reward;
            end
            disp([num2ordinal((i-1)*GridN2+j), ' (trj) evaluation, ', num2ordinal(iPI), ' iteration']);
        end
    end
    theta_v = C\b; %C\b means the least-squares solution.
    disp([num2ordinal(iPI), ' iteration done...']);
    theta_v_trj = [theta_v_trj theta_v]; % Collecting the obtained weights of the RBFVN for plotting...
end

figure
plot(0:nPI, theta_v_trj') % Plotting the evolution of the weights of the RBFVN
grid on;
title('Evolution of the weights $\theta_i$ of the RBFVN', 'Interpreter', 'latex');
ylabel('Amplitude', 'Interpreter', 'latex');
xlabel('Iteration', 'Interpreter', 'latex');

figure
Plot3DofRBFNOutput(theta_v, sprintf('The value function $v_i(x)$ ($i = %d$)', nPI)); % Draw 3D-plot of the final v_i(x)

disp('Learning completed.....')

% Test phase...

disp('Test the policies in the learning process....')

% time variable (re-)initialization for simulation and plotting...
t_f = 10;
t_f_iter = t_f/ts;
t_line = 0:ts:t_f;

% initialization of the simulation and plotting...
X = zeros(4,t_f_iter+1);
u = zeros(2,t_f_iter+1);

eps = 0.0;
init_bias = 1;

iIndex = [1, 2, 3, 4, nPI] + 1;

% Simulation for the obtained final policy starts...
figure
legends = [];
for iPI = iIndex
    theta_v = theta_v_trj(:,iPI);
    X(:,1) = init_bias.*[pi 0 pi 0]';
    
    for k = 1:t_f_iter
        u(:,k) = ACTION_GENERATOR(X(:,k));
        X(:,k+1) = rk4_closed(X(:,k), 'reward');
        if abs(X(1,k+1)) > (1+eps)*pi
            X(:,k+1) = Normalize_x1(X(:,k+1));
        end
    end
    u(k+1) = ACTION_GENERATOR(X(:,k+1));
    str = GetMarker4TrjGraph(iPI, iIndex, 'Type_0');
    plot(t_line, X(3,:), str, 'LineWidth', 1.3);
    legends = [legends ; ['{\it i}', sprintf(' = %2d', iPI - 1)]];
    disp(['the cummulative reward for the ', num2ordinal(iPI-1),' policy is ', num2str(X(4,t_f_iter))]);
    hold on
end
hold off

ylabel('Amplitude', 'Interpreter', 'latex');
xlabel('Time ([s])', 'Interpreter', 'latex');
hl = legend(legends);
set(hl, 'Interpreter', 'latex', 'FontName', 'Times New Roman');
title('Pendulum state trajectory $X_{1t}$ under $\pi_i$','Interpreter','latex');

figure
plot(t_line, u, '-b', 'LineWidth', 1.3)
ylabel('Amplitude','Interpreter','latex');
xlabel('Time ([s])','Interpreter','latex');
title(['Action trajectory $U_t$ under $\pi_i$ ', sprintf('($i = %d$)', nPI)], 'Interpreter', 'latex');  
disp('Simulation completed... ')
save(['.\data\', Method, '_', Reward_type, '_', Control_type]);

end  % end Main


function Plot3DofRBFNOutput(theta,fig_title)
global x1_bound;global x2_bound;
GridN1 = 50;
GridN2 = 50; % # of grids in one direction for plotting...

pre_x1 = [-x1_bound:x1_bound/(GridN1-1):x1_bound]'; % the grid points in x1
pre_x2 = [-x2_bound:x2_bound/(GridN2-1):x2_bound]'; % the grid points in x2

l1 = length(pre_x1);
l2 = length(pre_x2);

[x1, x2] = meshgrid(pre_x1,pre_x2);
z = zeros(l1,l2);

for i = 1:l1
    for j = 1:l2
        y1 = x1(i,j);
        y2 = x2(i,j);
        z(i,j) = NNFire(theta,[y1;y2]);
    end
end

% 3D plotting the obtained value function
surf(x1,x2,z,'EdgeColor','none','LineStyle','none','FaceLighting','phong');
% Using surf instead of mesh(x1,x2,z); mesh causes black-out for large GridN

title(fig_title,'Interpreter','latex');

xlabel('$x_1$','Interpreter','latex');
ylabel('$x_2$','Interpreter','latex','FontName','Times New Roman');
zlabel('Amplitude','Interpreter','latex');
end

