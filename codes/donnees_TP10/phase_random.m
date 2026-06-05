function Y_modifie = phase_random(Y)
% rend la phase de chaque frequence aleatoire
amplitude = abs(Y);
phase_aleatoire = 2 * pi * rand(size(Y));
Y_modifie = amplitude .* exp(1i * phase_aleatoire);

end