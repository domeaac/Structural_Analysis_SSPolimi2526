clear, clc, syms L x

nodes_order = 2; % 1 for truss, 2 for beam
number_of_nodes = 2;  
nodal_coordinates = [0; L];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
syms u [number_of_nodes 1] 
syms EA EJ
% 
S = ShapeMatrix(number_of_nodes, nodes_order, nodal_coordinates);
list = symvar(S); assume(list, "real");
S2 = diff(S, x, nodes_order);
list = symvar(S2); assume(list, "real");
EA = @(x) EJ;
Matrix = int(S2'*S2 * EA, x, 0,nodal_coordinates(end))
