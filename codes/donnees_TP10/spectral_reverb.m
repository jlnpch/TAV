function Y_modifie = spectral_reverb(Y, amount)
    % simule une résonance métallique 
    % amount : quantité de reverbe presente (entre 0 et 1)
    

    [nb_freqs, nb_temps] = size(Y);
    vecteur_amount = amount*linspace(1, 0.3, nb_freqs)';
    
    Y_modifie = zeros(nb_freqs, nb_temps);
    Y_modifie(:, 1) = Y(:, 1);

    for t = 2:nb_temps
        Y_modifie(:, t) = Y(:, t) + vecteur_amount.* Y_modifie(:, t-1);
    end

    facteur_norm = sqrt(1 - vecteur_amount.^2);
    Y_modifie = Y_modifie .* repmat(facteur_norm, 1, nb_temps);
end