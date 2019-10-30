function phi = NNHiddenFire(x)
global RBFN_centers1; global RBFN_centers2;
global N1; global N2;
global sig1; global sig2;
z = zeros(N1*N2, 1);
for j = 1:N2
    for i = 1:N1
        z((j-1)*N1+i) = sig1*(x(1) - RBFN_centers1(i))^2 + sig2*(x(2) - RBFN_centers2(j))^2;
    end
end
phi = exp(-z);
end