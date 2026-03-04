% 2. Trasforma il sistema di equazioni in forma matriciale: A*c = 0
[A_bc, b_bc] = equationsToMatrix(eqs, c);
% 3. Trova lo SPAZIO NULLO (Kernel) della matrice dei vincoli
% Il kernel rappresenta tutte le combinazioni di coefficienti che soddisfano le BCs
null_space = null(A_bc); 
% Dato che L è reale, posso imporre conj(L) = L
null_space = subs(null_space', conj(L), L);
null_space = simplify(null_space);
% 4. Genera la NUOVA BASE ottimizzata per Ritz
% Ogni colonna di null_space è una combinazione dei coefficienti originali
phi = null_space*base(:); % Questo è un vettore riga di funzioni "ammissibili"
phi = phi(:);           % Lo rendiamo vettore colonna
if override_phi 
    phi = phioverridden;
end
assume(x, "real"); assume(L, "real");
% Soluzione particolare che soddisfa w(0)=0, w(L)=th
c_p = A_bc \ b_bc;
w_p = simplify(subs(w_temp, c, c_p));
% Deflessione totale per Ritz:
% w(x) = w_p(x) + phi.' * cc
syms cc [1 max(size(phi))] real 
w = simplify(w_p + cc*phi);
% DISPLAY RESULTS
fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% \n')
fprintf('RITZ BASE with imposed bcs: \n')
disp(phi)
fprintf('PARTICULAR SOLUTION: \n')
disp(w_p)
fprintf('GENERAL SOLUTION FORM: \n')
disp(w)

ausphi = diff(phi,x, nmodel);
tempK = ausphi(:)*ausphi';
K = int(tempK.*stiffnessfunc, x, integralstart, integralend);
% fprintf('partial K MATRIX: \n')
% disp(K)

%%% validare da qui
fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% \n')
% fprintf('particular solution contribution to the f vector \n')
f0 = int(-ausphi(:).*stiffnessfunc*diff(w_p,x,nmodel),x, integralstart, integralend);
% disp(f0)
warning('springs always count as a positive contibution to internal work')
warning('the virtual displacement never includes the particular solution, only the true displacement does')
fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% \n')

if loads 
    floads = loadvalue.*subs(phi(:), x, loadlocation);
else
    floads = zeros(max(size(f0)), 1);
end

if distributedloads
    fdl = int(phi(:)*dl, dl_start, dl_end);
else
    fdl = zeros(max(size(f0)), 1);
end

% VALIDARE TORSIONAL SPRINGS
if springs 
    if strcmp(typespring, 'displacement')
      Ks = subs(phi(:),x,springlocation)*subs(phi,x,springlocation)'*k;
    end
    if strcmp(typespring, 'torsional')
      dphi = diff(phi,x, 1);
      Ks = subs(dphi(:),x,springlocation)*subs(dphi,x,springlocation)'*k;
    end
else
    Ks = zeros(max(size(f0)), 1);
end

if distributedsprings
    if strcmp(typedspring, 'displacement')
      Kds = int(phi(:)*phi'*kds, kds_start, kds_end);
    end
    if strcmp(typedspring, 'torsional')
      dphi = diff(phi,x, 1);
      Kds = int(dphi(:)*dphi'*kds, kds_start, kds_end);
    end
else
    Kds = zeros(size(K,1), size(K,2));
end

f = f0 + fdl + floads;
Kfinal = K + Kds + Ks;
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

displacement_function = phi(:)'*cfinal + w_p;

%%%%%%%%%%%%%%%%%%%% DISPLACEMENT EVALUATION %%%%%%%%%%%%%%%%%%%%%%%
displacement = subs(displacement_function, x, where);
fprintf('displacement function: %s \n', displacement_function);
fprintf('\ndisplacement value in %s: %s \n', where, displacement);

K = Kfinal; % safety 