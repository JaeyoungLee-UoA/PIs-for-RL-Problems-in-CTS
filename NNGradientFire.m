function y = NNGradientFire(theta,x)
y = theta'*NNHiddenGradientFire(x);
end