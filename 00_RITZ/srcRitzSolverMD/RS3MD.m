if distributedmass
    M1 = int(phi(:)*phi'*distributedmassfunc, x, dmf_start, dmf_end);
else
    M1 = zeros(size(K,1), size(K,2));
end

if mass
    M2 = subs(phi,x,masslocation)*subs(phi,x,masslocation)'*massvalue;
else
    M2 = zeros(size(K,1), size(K,2));
end

M = M1 + M2;
omegas = simplify(sqrt(eig(inv(M)*K)));
fprintf('natural frequencies (rad/s): %s \n', omegas);
fprintf('natural frequencies (Hz): %s \n', omegas/(2*pi));
% -w^2 M + K = 0
% K = w^2 M
% M^-1 K = w^2
% M^-1 K v = w^2 v
% w = sqrt(eig(M^-1 K)