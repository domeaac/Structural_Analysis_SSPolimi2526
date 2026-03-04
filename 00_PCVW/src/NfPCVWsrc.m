%%%%%%%%%% SOURCE CODE
ls = conj_length;
% missing_eqs = max(size(av)) - max(size(eqbrs));
% plv_indexes = shift+1:shift+missing_eqs;
av = plvars;
plv_indexes = 1:max(size(av));


dWi = [];
if override_dWe 
    dWe = imposed_dWe;
else
dWe = zeros(max(size(plv_indexes)),1);
end

for i = 1:max(size(plv_indexes))
    da = diff(actions, av(i), 1);

    inte = 0;
    for j = 1:max(size(actions)) 
         inte = inte + int(actions(j)*da(j)/conj_stiffness(j), x, 0, ls(j));
    end

    dWi = [dWi; inte];
end
    
plvs = []; 
for i = 1: max(size(dWi))
    plvs = [plvs; dWi(i) == dWe(i)];
end

equations = [eqbrs; plvs];
solution = solve(equations, vs);

fprintf('skibidi')
pause(0.07)
clc

if numerical_solution && max(size(plvars)) == 1
% Conversione della struct solution in valori numerici
nomi = fieldnames(solution);
for i = 1:numel(nomi)
    val = double(subs(solution.(nomi{i}), dati));
    fprintf('%s = %.4f\n', nomi{i}, val);
end

else
    solution
end
