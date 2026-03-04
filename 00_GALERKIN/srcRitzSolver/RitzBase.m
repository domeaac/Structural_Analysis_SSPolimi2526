function base = RitzBase(n, type)
    syms x L
    switch lower(type)
        case 'monomial'
            % Genera: [1; x; x^2; ...; x^(n-1)]
            base = (x.^(0:n-1));
            base = base(:);
            
        case 'polynomial'
            % Genera polinomi traslati (es. per condizioni al contorno 0..L)
            % Qui usiamo la forma (x/L)^i
            base = (x/L).^(0:n-1);
            base = base(:);
            
        case 'harmonic'
            % Genera: [1; sin(1*pi*x/L); cos(1*pi*x/L); sin(2*pi*x/L); ...]
            % Nota: l'ordine n determina quanti termini includere
            b = [sym(1)]; 
            for i = 1:ceil((n-1)/2)
                b = [b; sin(i*pi*x/L); cos(i*pi*x/L)];
            end
            base = b(1:n); % Taglia al numero esatto di termini richiesti
            
        case 'sym_cosines'
            % Genera: [1; sin(1*pi*x/L); cos(1*pi*x/L); sin(2*pi*x/L); ...]
            % Nota: l'ordine n determina quanti termini includere
            b = [sym(1)]; 
            for i = 1:n-1
                b = [b; cos(2*i*pi*x/L)];
            end
            base = b;
            
        otherwise
            error('Tipo di base non supportato');
    end
end