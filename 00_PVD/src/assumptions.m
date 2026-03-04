% it is assumed that the beam axis runs along the centroids of the beam's
% sections

% the solver solves for generalised displacements, not actual
% displacements. the actual displacement of a generic point is given by the
% specific kinematic model of the problem

% forces often enter the problem via BCs, as long as no loads are
% applied within the domain

% In a general case, where the properties of the system are a variable
% along its dimensions, proper derivatives need to be accounted for

% THE UNCOUPLING BETWEEN BEHAVIOURS DOES NOT IMPLY THAT DIFFERENT PVDS CAN
% BE USED IN A SYSTEM: THE PVD IS ALWAYS A SINGLE SCALAR EQUATION EMBEDDING
% ALL THE CONTRIBUTIONS. The full expression is always the complete one,
% but often terms are ignored due to their already known zero-solution