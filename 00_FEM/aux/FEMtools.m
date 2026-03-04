clear, clc
syms L

number_of_nodes = 3;
nodal_coordinates = [0; L/2; L];
DOFS = 2;

syms u [number_of_nodes 1]
shape_functions = ShapeFunctions(number_of_nodes, nodal_coordinates);
shape_fcs_matrix = ShapeMatrix(nDOFS, number_of_nodes, nodal_coordinates);
functions = shape_functions*u;