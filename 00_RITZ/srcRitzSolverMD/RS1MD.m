
base1 = RitzBase(n1, basetype1); % Base espansione
nomi = symvar(base1); assume(nomi, "real");
syms c1 [n1 1] real    
w_temp1 = base1' * c1;

base2 = RitzBase(n2, basetype2);
syms x2, base2 = subs(base2, x, x2);
nomi = symvar(base2); assume(nomi, "real");
syms c2 [n2 1] real     
w_temp2 = base2' * c2;