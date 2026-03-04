function [] = PrintLumpedMatrices()
    % Questa funzione stampa a terminale le matrici di massa lumpata
    % descritte nel documento FEM - 1D elements.
    
    fprintf('--- Matrici di Massa Lumpata (Lumped Mass Matrices) ---\n\n');

    %% 1. Rod Element (Asta)
    % Secondo l'equazione (3.6), la massa totale mh è divisa equamente tra i due nodi[cite: 34, 36].
    fprintf('1. Rod Element Matrix [M_rod(L)]:\n');
    fprintf('   (mh/2) * [1  0]\n');
    fprintf('            [0  1]\n\n');

    %% 2. Beam Element (Trave)
    % Secondo l'equazione (3.18), i gradi di libertà traslazionali ricevono mh/2, 
    % mentre per i rotazionali si usa un'inerzia I_theta[cite: 96, 97].
    fprintf('2. Beam Element Matrix [M_beam(L)]:\n');
    fprintf('   [mh/2    0      0      0   ]\n');
    fprintf('   [  0    I_theta  0      0   ]\n');
    fprintf('   [  0      0    mh/2     0   ]\n');
    fprintf('   [  0      0      0    I_theta]\n');
    fprintf('   *Nota: I_theta puo essere 0 o mh^3/78 (metodo HRZ)\n\n');

    %% 3. Beam-Rod Element (Trave-Asta)
    % Combinazione dei precedenti, risultante in una matrice diagonale 6x6[cite: 160, 161].
    fprintf('3. Beam-Rod Element Matrix [M_br(L)]:\n');
    fprintf('   [mh/2   0     0     0     0     0   ]\n');
    fprintf('   [  0   mh/2   0     0     0     0   ]\n');
    fprintf('   [  0     0   I_theta  0     0     0   ]\n');
    fprintf('   [  0     0     0    mh/2   0     0   ]\n');
    fprintf('   [  0     0     0     0    mh/2   0   ]\n');
    fprintf('   [  0     0     0     0     0   I_theta]\n');
    
end