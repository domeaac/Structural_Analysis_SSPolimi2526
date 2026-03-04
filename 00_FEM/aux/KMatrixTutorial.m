clear, clc, syms L x

nodes_order = 2; % 1 for truss, 2 for beam, 
                 % 3 for truss beam, which is only available in 2 nodes form
number_of_nodes = 2;  
nodal_coordinates = [0; L];
syms EA EJ
vars = [];
stiffness_function = @(x) EJ;


KMatrix(number_of_nodes, nodes_order, nodal_coordinates, stiffness_function, vars)
