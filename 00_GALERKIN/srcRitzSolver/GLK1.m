
base = RitzBase(n, basetype); % Base espansione
assume(x, "real"); assume(L, "real");
syms c [n 1] real      
% 1. Definisci le condizioni al contorno (BCs) come equazioni
% Esempio: Incastro in 0 [w(0)=0, w'(0)=0] e appoggio in L [w(L)=0]
w_temp = base' * c;