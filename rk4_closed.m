function [X_n, U_n] = rk4_closed(X, opt) % Caculate the next values using rk4...
global rk4_c; global rk4_ts;

K1=rk4_ts*feval('CLOSED_LOOP_SYS', X, feval('ACTION_GENERATOR', X), opt);
X1 = X + 0.5*K1;

K2=rk4_ts*feval('CLOSED_LOOP_SYS', X1, feval('ACTION_GENERATOR', X1), opt);
X2 = X + 0.5*K2;

K3=rk4_ts*feval('CLOSED_LOOP_SYS', X2, feval('ACTION_GENERATOR', X2), opt);
X3 = X + K3;

K4=rk4_ts*feval('CLOSED_LOOP_SYS', X3, feval('ACTION_GENERATOR', X3), opt);

X_n = X + [K1,K2,K3,K4]*rk4_c;
U_n = feval('ACTION_GENERATOR', X_n);
end
