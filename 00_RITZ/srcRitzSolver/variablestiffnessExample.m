function [] = variablestiffnessExample()
% EXAMPLE: VARIABLE STIFFNESS
% syms a0 y E
% a = @(x) 2*a0 - a0*x/L;
% J = @(xx) int(int(y^2, x, -a(xx)/2, a(xx)/2), y, -a(xx)/2, a(xx)/2);
% stiffnessfunc = @(x) E*J(x); %provide a stiffness function
end

