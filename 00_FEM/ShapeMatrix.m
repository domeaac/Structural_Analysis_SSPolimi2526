function [S] = ShapeMatrix(number_of_nodes, nodes_order, nodal_coordinates)

syms u [number_of_nodes 1]
shape_functions = ShapeFunctions(number_of_nodes, nodes_order, nodal_coordinates);

S = shape_functions;
%S = diag(shape_functions);
% for i = 2:nodes_order
%         S = [S, zeroes];
% end

end
