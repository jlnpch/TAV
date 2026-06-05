function Y_modifie = passe_bas(Y, valeurs_f, f_cut)
%passe_bas applique un passe bas au signal
%   Detailed explanation goes here

[l,c] = size(Y);
i_cut = find(valeurs_f >= f_cut, 1);

Y_modifie = Y;
Y_modifie(i_cut:end,:) = zeros(l-i_cut+1,c);

end