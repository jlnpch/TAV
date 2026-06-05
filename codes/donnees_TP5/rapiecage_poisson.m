function [u_k, D] = rapiecage_poisson(bornes_V_p, bornes_V_q_chapeau, u_k, D)
% remplace les pixels manquants par clonage de gradient

ip_min = bornes_V_p(1);
ip_max = bornes_V_p(2);
jp_min = bornes_V_p(3);
jp_max = bornes_V_p(4);

iq_min = bornes_V_q_chapeau(1);
iq_max = bornes_V_q_chapeau(2);
jq_min = bornes_V_q_chapeau(3);
jq_max = bornes_V_q_chapeau(4);

% 2. Extraction des sous-matrices locales
% r_local : Le patch cible (qui contient le bout de trou à boucher et les bords sains)
r_local = u_k(ip_min:ip_max, jp_min:jp_max, :);

% s_local : Le patch source (la forêt saine trouvée par l'algo de Criminisi)
s_local = u_k(iq_min:iq_max, jq_min:jq_max, :);

% 3. Extraction du masque local
masque_local = D(ip_min:ip_max, jp_min:jp_max);
interieur = find(masque_local == 1);

% --- LA FUSION TP5 / TP7 ---
% Si le trou n'est pas vide dans ce patch, on lance le solveur de Poisson local
if ~isempty(interieur)

    % On utilise DIRECTEMENT votre fonction du TP7 !
    % r_local sert de conditions aux limites, s_local fournit le gradient.
    patch_seamless = collage(r_local, s_local, interieur);

    % Sécurité : on borne les valeurs pour éviter les artefacts de calcul
    patch_seamless = max(0, min(255, patch_seamless));

    % 4. Mise à jour de l'image globale
    % Attention : collage() renvoie un patch entier. On ne met à jour que l'intérieur !
    for c = 1:size(u_k, 3)
        canal_u    = u_k(ip_min:ip_max, jp_min:jp_max, c);
        canal_pois = patch_seamless(:,:,c);

        % On remplace uniquement les pixels qui étaient à restaurer
        canal_u(interieur) = canal_pois(interieur);
        u_k(ip_min:ip_max, jp_min:jp_max, c) = canal_u;
    end
end

% 5. Mise à jour du domaine D global
D(ip_min:ip_max, jp_min:jp_max) = 0;

end