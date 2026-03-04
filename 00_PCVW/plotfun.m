function plotfun(fun_sym, L)
% PLOTFUN Plotta una funzione simbolica da 0 a L
%   fun_sym: variabile simbolica (es. displacement_function)
%   L: valore numerico del limite superiore del plot

    % 1. Identifichiamo la variabile x all'interno della funzione
    % Se la funzione è costante, symvar potrebbe essere vuota
    vars = symvar(fun_sym);
    
    if isempty(vars)
        % Se è una costante, definiamo x per il plot
        syms x
        f_to_plot = fun_sym + 0*x; 
    else
        % Assumiamo che la variabile di interesse sia x (o la prima trovata)
        f_to_plot = fun_sym;
    end

    % 2. Creazione del plot
    figure; % Apre una nuova finestra
    fplot(f_to_plot, [0, L], 'LineWidth', 2);
    
    % 3. Estetica del grafico
    grid on;
    xlabel('x');
    ylabel('f(x)');
    title(['Plot di ', char(fun_sym)]);
    
    % Aggiungiamo un limite agli assi per chiarezza
    xlim([0, L]);
end