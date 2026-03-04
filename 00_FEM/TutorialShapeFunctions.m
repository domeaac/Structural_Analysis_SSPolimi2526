clear, clc, syms L x

nodes_order = 2;
number_of_nodes = 2; 
nodal_coordinates = [0; L];


% EVALUATE THE CORRESPONDING SHAPE FUNCTIONS
% 3 nodes element, with nodes located at [0; L/2; L]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
shape_functions = ShapeFunctions(number_of_nodes, nodes_order, nodal_coordinates);

syms u [nodes_order*number_of_nodes 1]
assume(u, "real"); assume(L, "real"); assume(x, "real");
disp(shape_functions')
functions = shape_functions*u;
%disp(functions');