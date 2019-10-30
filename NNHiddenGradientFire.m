function phi = NNHiddenGradientFire(x)
global RBFN_centers1; global RBFN_centers2;
global N1; global N2;
global sig1; global sig2;
phi = zeros(N1*N2, 2);
for j = 1:N2
    for i = 1:N1
        e = [x(1) - RBFN_centers1(i) ; x(2) - RBFN_centers2(j)];
        phi((j-1)*N1+i,:) = -2*exp(-sig1*e(1)^2 - sig2*e(2)^2)*[e(1)*sig1 e(2)*sig2];
    end
end
end