function [] = PrintOtherMatrices()
    % Questa funzione stampa le matrici di massa consistenti descritte nel pdf.
    % Le matrici consistenti sono ottenute dalla stessa approssimazione degli 
    % spostamenti usata per la rigidezza.

    fprintf('--- Matrici di Massa Consistenti ---\n\n');

    %% 1. Rod Element (Matrice Coerente)
    % Calcolata dal lavoro virtuale delle forze d'inerzia[cite: 27].
    % Presenta termini fuori diagonale che indicano accoppiamento[cite: 31].
    fprintf('1. Rod Element - Consistent Mass Matrix [M_rod]:\n');
    fprintf('   (mh/6) * [2  1]\n');
    fprintf('            [1  2]\n\n'); 

    %% 2. 2-D Truss Element (Matrice Coerente)
    % Derivata considerando che il moto trasversale ora fornisce un contributo[cite: 58].
    % Matrice 4x4 per i gradi di libertà (UL, VL, UR, VR)[cite: 50, 57].
    fprintf('2. 2-D Truss Element - Consistent Mass Matrix [M_truss]:\n');
    fprintf('   (mh/6) * [2  0  1  0]\n');
    fprintf('            [0  2  0  1]\n');
    fprintf('            [1  0  2  0]\n');
    fprintf('            [0  1  0  2]\n\n'); 

    %% 3. Beam Element (Matrice Coerente)
    % Basata su funzioni di forma Hermitiane[cite: 82, 89].
    % Matrice 4x4 per i gradi di libertà (vL, thetaL, vR, thetaR)[cite: 79, 89].
    fprintf('3. Beam Element - Consistent Mass Matrix [M_beam]:\n');
    fprintf('   (mh/420) * [ 156    22h    54   -13h ]\n');
    fprintf('              [ 22h    4h^2   13h  -3h^2 ]\n');
    fprintf('              [  54    13h    156  -22h  ]\n');
    fprintf('              [ -13h  -3h^2  -22h   4h^2 ]\n\n'); 

    %% 4. Beam-Rod Element (Matrice Coerente)
    % Combinazione dei contributi assiali e flessionali[cite: 135].
    % Matrice 6x6 che include spostamenti u, v e rotazione theta[cite: 112, 144].
    fprintf('4. Beam-Rod Element - Consistent Mass Matrix [M_br]:\n');
    fprintf('   (mh/420) * [ 140    0      0     70     0      0   ]\n');
    fprintf('              [  0    156    22h     0     54   -13h  ]\n');
    fprintf('              [  0    22h    4h^2    0     13h  -3h^2 ]\n');
    fprintf('              [  70    0      0    140     0      0   ]\n');
    fprintf('              [  0     54    13h     0    156   -22h  ]\n');
    fprintf('              [  0    -13h  -3h^2    0    -22h   4h^2  ]\n'); 

end