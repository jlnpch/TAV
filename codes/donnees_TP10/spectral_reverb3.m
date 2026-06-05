function Y_modifie = spectral_reverb3(Y, amount, pre_delay, diffusion)
    % simule une résonance métallique avec plus de controle
    % amount : quantité de reverbe presente (entre 0 et 1)
    % pre delay : temps avant que le son a la frame t soit "reverberé"
    % diffusion : quantite de modification de la phase (aspect metallique)
    
    [nb_freqs, nb_temps] = size(Y);
    vecteur_amount = amount*linspace(1, 0.3, nb_freqs)';

    Y_modifie = zeros(nb_freqs, nb_temps);
    Y_modifie(:, 1:pre_delay+2) = Y(:, 1:pre_delay+2);
    
    for t = (pre_delay + 3):nb_temps
        
        bruit_phase = exp(1i * (rand(nb_freqs, 1) * 2 * pi - pi) * diffusion);
        % on ajoute le a t les frequences de t - predelay auquelles on
        % ajoute du bruit sur la phase
        smearing = (Y_modifie(:, t-pre_delay) + Y_modifie(:, t-pre_delay-1) + Y_modifie(:, t-pre_delay-2)) / 3;

        Y_modifie(:, t) = Y(:, t) + vecteur_amount .*smearing.* bruit_phase;
    end
    
    % Normalisation
    facteur_norm = sqrt(1 - vecteur_amount.^2);
    Y_modifie = Y_modifie .* repmat(facteur_norm, 1, nb_temps);
end