function [N] = ShapeFunctions(nodes, nodes_order, coordinates)

n = nodes*nodes_order;

syms x
syms nodal_bcs [n 1]  % Rappresenta lo spostamento ai nodi (u1, u2, ...)

base = RitzBase(n, 'polynomial');
syms a [1 n]
u_x = a*base;

eqs = zeros(n, 1, 'sym');

for i = 0:nodes-1
    count = 1;
   while count <= nodes_order
       eqs(i*nodes_order + count) = subs(diff(u_x, x, count-1), x, coordinates(i+1)) == nodal_bcs(i*nodes_order+count);
       count = count + 1;
   end
end

[M, b] = equationsToMatrix(eqs, a);
a_solved = M \ b;


nomi = symvar(a);
assume(nomi, "real");
nomi = symvar(a_solved);
assume(nomi, "real");
nomi = symvar(u_x);
assume(nomi, "real");
u_final = subs(u_x, a, a_solved');
[N, ~] = equationsToMatrix(u_final, nodal_bcs);
N = simplify(N);

end
