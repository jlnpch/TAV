function Y_modifie = passe_haut(Y, valeurs_f, f_cut)
%passe_bas applique un passe haut au signal
[~,c] = size(Y);
i_cut = find(valeurs_f >= f_cut, 1);

Y_modifie = Y;
Y_modifie(1:i_cut,:) = zeros(i_cut,c);

end