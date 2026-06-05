function [Y_modifie] = spectral_gate(Y, seuil_db, mix)
% supprime les frequences en dessous du seuil de niveau sonore 
%   seuil_db : seuil en db
%   mix      : 1 ne garde que les frequences fortes, 0 ne garde que les bruits faibles, entre  0 et 1 mix des deux signaux)

S_db = 20 * log10(abs(Y) + eps);

%masques
masque_fort = double(S_db >= seuil_db);
masque_faible = double(S_db < seuil_db);

% melange des masques et application
gain = (masque_fort .* mix) + (masque_faible .* (1 - mix));
Y_modifie = Y .* gain;

end