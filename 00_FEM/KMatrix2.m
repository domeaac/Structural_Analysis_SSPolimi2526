function [K] = KMatrix(number_of_nodes, nodes_order, nodal_coordinates, stiffness_function, vars)
syms x
nomi = symvar(vars); syms(nomi);
S = ShapeMatrix(number_of_nodes, nodes_order, nodal_coordinates);
list = symvar(S); assume(list, "real");
S2 = diff(S, x, nodes_order);
list = symvar(S2); assume(list, "real");
K = int(S2'*S2 * stiffness_function, x, 0,nodal_coordinates(end));

end

