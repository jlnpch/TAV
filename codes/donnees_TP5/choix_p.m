function indice_p_choisi = choix_p(indices_delta_D, D, u_k, t)
% CHOISIR_PIXEL_PRIORITAIRE : choisi le pixel de delta_P

[nb_lignes, nb_colonnes, nb_canaux] = size(u_k);
nb_points = length(indices_delta_D);

indice_p_choisi = 0;
priorite_max = 0;

for k = 1:nb_points
    [i_p, j_p] = ind2sub([nb_lignes, nb_colonnes], indices_delta_D(k));

    i_min = max(1, i_p - t);
    i_max = min(nb_lignes, i_p + t);
    j_min = max(1, j_p - t);
    j_max = min(nb_colonnes, j_p + t);

    masque_V = D(i_min:i_max, j_min:j_max);

    nb_pixels_total = numel(masque_V);
    nb_pixels_sains = sum(~masque_V, 'all');
    C_p = nb_pixels_sains / nb_pixels_total;

    patch_u = u_k(i_min:i_max, j_min:j_max, :);
    variance_locale = 0;

    for c = 1:nb_canaux
        canal = patch_u(:,:,c);
        pixels_sains_canal = canal(~masque_V);
        if length(pixels_sains_canal) > 1
            variance_locale = variance_locale + var(pixels_sains_canal);
        end
    end

    D_p = log(1 + variance_locale) + 0.1;
    % D_p = variance_locale + 0.1;

    priorite = C_p*D_p;
    if priorite > priorite_max
        priorite_max = priorite;
        indice_p_choisi = indices_delta_D(k);
    end
end

end