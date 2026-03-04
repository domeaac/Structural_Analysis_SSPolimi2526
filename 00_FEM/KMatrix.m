function [K, SS] = KMatrix(number_of_nodes, nodes_order, nodal_coordinates, stiffness_function, vars)
syms x
nomi = symvar(vars); syms(nomi);
if nodes_order == 1 || nodes_order == 2
    S = ShapeMatrix(number_of_nodes, nodes_order, nodal_coordinates);
    list = symvar(S); assume(list, "real");
    S2 = diff(S, x, nodes_order);
    list = symvar(S2); assume(list, "real");
    K = int(S2'*S2 * stiffness_function, x, 0,nodal_coordinates(end));
end
if nodes_order == 3
    nodes_order = 1; syms EA; stiffness_function = @(x) EA;
    S = ShapeMatrix(number_of_nodes, nodes_order, nodal_coordinates);
    list = symvar(S); assume(list, "real");
    S2 = diff(S, x, nodes_order);
    list = symvar(S2); assume(list, "real");
    K1 = int(S2'*S2 * stiffness_function, x, 0,nodal_coordinates(end));
    nodes_order = 2; syms EJ; stiffness_function = @(x) EJ;
    S = ShapeMatrix(number_of_nodes, nodes_order, nodal_coordinates);
    list = symvar(S); assume(list, "real");
    S2 = diff(S, x, nodes_order);
    list = symvar(S2); assume(list, "real");
    K2 = int(S2'*S2 * stiffness_function, x, 0,nodal_coordinates(end));
    Z = zeros(1,2);
    K = [K1(1,1) Z K1(1,2) Z
        Z' K2(1:2, 1:2) Z' K2(1:2, 3:4) 
        K1(2,1) Z K1(2,2) Z
        Z' K2(3:4, 1:2) Z' K2(3:4, 3:4)];

    nodes_order = 3;

end
nomi = symvar(S); assume(nomi, "real");
SS = S';
if nodes_order ~= 1 && nodes_order ~= 2 && nodes_order ~= 3 
    error('NODES ORDER NON SUPPORTATO')
end

end

