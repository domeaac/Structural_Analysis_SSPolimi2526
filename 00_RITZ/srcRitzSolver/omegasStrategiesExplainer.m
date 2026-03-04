function [] = omegasStrategiesExplainer()
% ===========================================================================
% ANALISI STRATEGICA ESERCIZIO 5: GENERAZIONE BASI TRAMITE DEFORMATE STATICHE
% ===========================================================================
% 
% 1. OBIETTIVO DELLA PROCEDURA
% [cite_start]L'Esercizio 5 confronta diverse strategie per definire la funzione di prova (trial function) phi_1 nel metodo di Ritz[cite: 341, 345]. 
% [cite_start]L'obiettivo non è aggiungere carichi esterni al problema (che resta di vibrazione libera), 
%             ma trovare una forma della base che "assomigli" il più possibile al vero modo di vibrare per ottenere la
%             massima precisione con il minimo numero di gradi di libertà (1-DOF)[cite: 347, 349].
% 
% 2. PERCHÉ USARE CARICHI AUSILIARI (P e q)?
% [cite_start]La forma della vibrazione dipende dal rapporto tra l'inerzia distribuita della trave (Io) e la 
%             massa concentrata in punta (M_hat)[cite: 377, 378, 385].
%    * [cite_start]Caso 3a (Carico in punta P): Si usa se M_hat >> Io*L[cite: 386]. 
%                  La trave vibra trascinata dalla massa finale. [cite_start]Si risolve l'ODE statica EJ*w'''' = 0 
%                  imponendo una condizione naturale di taglio non nullo in punta: w'''(L) = -P/EJ[cite: 393, 397].
%    * [cite_start]Caso 3b (Carico distribuito q): Si usa se M_hat << Io*L[cite: 387]. 
%                  La trave vibra seguendo la propria distribuzione di massa. [cite_start]Si risolve l'ODE non omogenea EJ*w'''' = q 
%                  con condizioni naturali di taglio e momento nullo in punta[cite: 411, 413].
% 
% 3. COSA CAMBIA NEL SISTEMA RISOLVENTE?
%    * [cite_start]CC ESSENZIALI: Rimangono invariate (incastro in x=0: w=0, w'=0) poiché il vincolo fisico 
%                  è lo stesso per ogni approccio[cite: 351, 394, 414].
%    * [cite_start]BASE PHI: Invece di un polinomio generico (x^2), la phi_1 diventa una funzione "fisicamente intelligente" 
%                  (cubica per il carico P, quartica per il carico q)[cite: 402, 423, 427].
%    * MATRICI K ed H: Vengono calcolate usando queste nuove funzioni. [cite_start]La matrice di massa H includerà SEMPRE 
%                      sia il termine distribuito (Io) che quello concentrato (M_hat), a prescindere da come è stata generata la phi_1[cite: 349, 360, 405, 424].
% 
% 4. VANTAGGIO NUMERICO
% [cite_start]L'uso di una deformata statica permette a un modello con 1 solo grado di libertà (1-DOF) 
%             di raggiungere una precisione equivalente a un'espansione polinomiale con 4 gradi di libertà (N=4)[cite: 431, 448, 451].
% [cite_start]In pratica, si "investe" tempo nella risoluzione di un'ODE statica per semplificare drasticamente il problema agli autovalori finale[cite: 432].
% ===========================================================================
end

