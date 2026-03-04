% 2. Trasforma il sistema di equazioni in forma matriciale: A*c = 0
[A_bc, b_bc] = equationsToMatrix(eqs, [c1; c2]);
% 3. Trova lo SPAZIO NULLO (Kernel) della matrice dei vincoli
% Il kernel rappresenta tutte le combinazioni di coefficienti che soddisfano le BCs
null_space = null(A_bc); 
% Dato che L è reale, posso imporre conj(L) = L
null_space = subs(null_space', conj(L), L);
null_space = simplify(null_space);

% 4. Genera la NUOVA BASE ottimizzata per Ritz
% Ogni colonna di null_space è una combinazione dei coefficienti originali
phi1 = null_space(:,1:n1)*base1(:); 
phi1 = phi1(:);   

phi2 = null_space(:,n1+1:n1+n2)*base2(:); 
phi2 = phi2(:);  

if override_phi1 
    phi1 = phioverridden1;
end
if override_phi2
    phi2 = phioverridden2;
end

nomi = symvar(null_space); assume(nomi, "real");
nomi = symvar(phi1); assume(nomi, "real");
nomi = symvar(phi2); assume(nomi, "real");
% Soluzione particolare che soddisfa w(0)=0, w(L)=th
c_p = A_bc \ b_bc;
w_p1 = simplify(subs(w_temp1, c1 , c_p(1:n1)));
w_p2 = simplify(subs(w_temp2, c2 , c_p(n1+1:n1+n2)));

syms cc [1 max(size(phi1))] real 
w1 = simplify(w_p1 + cc*phi1);
w2 = simplify(w_p2 + cc*phi2);

%

ausphi1 = diff(phi1,x, nmodel1);
ausphi2 = diff(phi2,x2, nmodel2);

tempK1 = ausphi1(:)*ausphi1';
K1 = int(tempK1.*stiffnessfunc1, x, integralstart1, integralend1);
tempK2 = ausphi2(:)*ausphi2';
K2 = int(tempK2.*stiffnessfunc2, x2, integralstart2, integralend2);

% fprintf('partial K MATRIX: \n')
% disp(K)

f01 = int(-ausphi1(:).*stiffnessfunc1*diff(w_p1,x,nmodel1),x, integralstart1, integralend1);
f02 = int(-ausphi2(:).*stiffnessfunc2*diff(w_p2,x2,nmodel2),x2, integralstart2, integralend2);

if loads1
    floads1 = loadvalue1.*subs(phi1(:), x, loadlocation1);
    %floads1 = loadvalue1.*subs(diff(phi1(:), x, 1), x, loadlocation);
else
    floads1 = zeros(max(size(f01)), 1);
end

if distributedloads1
    fdl1 = int(phi1(:)*dl1, dl_start1, dl_end1);
else
    fdl1 = zeros(max(size(f01)), 1);
end

if springs1 
    Ks1 = subs(phi1(:),x,springlocation1)*subs(phi1,x,springlocation1)'*k1;
else
    Ks1 = zeros(max(size(f01)), 1);
end

if distributedsprings1
    Kds1 = int(phi1(:)*phi1'*kds1, kds_start1, kds_end1);
else
    Kds1 = zeros(size(K1,1), size(K1,2));
end

f1 = f01 + fdl1 + floads1;
Kfinal1 = K1 + Kds1 + Ks1;

if loads2 
    floads2 = loadvalue2.*subs(phi2(:), x2, loadlocation2);
    %floads2 = loadvalue2.*subs(diff(phi2(:), x2, 1), x2, loadlocation2);
else
    floads2 = zeros(max(size(f02)), 1);
end

if distributedloads2
    fdl2 = int(phi2(:)*dl2, dl_start2, dl_end2);
else
    fdl2 = zeros(max(size(f02)), 1);
end

if springs2 
    Ks2 = subs(phi2(:),x2,springlocation2)*subs(phi2,x2,springlocation2)'*k2;
else
    Ks2 = zeros(max(size(f02)), 1);
end

if distributedsprings2
    Kds2 = int(phi2(:)*phi2'*kds2, kds_start2, kds_end2);
else
    Kds2 = zeros(size(K2,1), size(K2,2));
end

f2 = f02 + fdl2 + floads2;
Kfinal2 = K2 + Kds2 + Ks2;

Kfinal = Kfinal1 + Kfinal2;
f = f1 + f2;
cfinal = Kfinal\f;

fprintf('Final K matrix (non L-normalised if monomials): \n')
disp(Kfinal)

fprintf('Final f value (non L-normalised if monomials): \n')
disp(f)

fprintf('Final c values: \n')
cfinal = simplify(cfinal);
disp(cfinal)

fprintf('Strain energy value: \n')
list = symvar(cfinal); assume(list, "real"); list = symvar(Kfinal); assume(list, "real")
strain_energy = 0.5* cfinal'*Kfinal*cfinal;
disp(strain_energy)

K = Kfinal; %safety