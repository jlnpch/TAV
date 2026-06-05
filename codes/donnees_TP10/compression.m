function [Y_modifie,taux_compression] = compression(Y, m)
%COMPRESSION compression naive du signal

[h, w] = size(Y);
Y_modifie = zeros(h, w);

[~, I] = maxk(Y, m, 1);

decalage_colonnes = 0:h:(w-1)*h;
I = I + decalage_colonnes;

Y_modifie(I) = Y(I);
taux_compression = h / m;

end