function y = NNFire(theta,x) % Implementation of the normalized RBFN.
y = theta'*NNHiddenFire(x);
end