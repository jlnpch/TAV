%--------------------------------------------------------------------------
% ENSEEIHT - 2SN MM - Traitement des donnees audio-visuelles
% TP5 - Restauration d'images
% criminisi : inpainting par rapiecage avec ordre de priorité (Criminisi & al.)
%--------------------------------------------------------------------------

clear
close all
clc

% Mise en place de la figure pour affichage :
taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);
figure('Name','Inpainting par rapiecage',...
	'Position',[0.06*L,0.1*H,0.9*L,0.75*H])

% Lecture de l'image :
u_0 = double(imread('Images/randonneur.jpg'));
[nb_lignes,nb_colonnes,nb_canaux] = size(u_0);
u_max = max(u_0(:));

% Affichage de l'image :
subplot(1,2,1)
	imagesc(max(0,min(1,u_0/u_max)),[0 1])
	axis image off
	title('Image originale','FontSize',20)
	if nb_canaux == 1
		colormap gray
	end

% Selection et affichage du domaine a restaurer :
% disp('Selectionnez un polygone (double-clic pour valider)')
% [D,x_D,y_D] = roipoly();
% for k = 1:length(x_D)-1
% 	line([x_D(k) x_D(k+1)],[y_D(k) y_D(k+1)],'Color','b','LineWidth',2);
% end

% D = imread('Images/masque_randonneur.png')>0;

% Lecture du domaine a restaurer :
D = imread('Images/masque_randonneur_2.png');
D = rgb2gray(D) > 0;
D_init = D;

% Affichage de l'image resultat :
u_k = u_0;
for c = 1:nb_canaux
	u_k(:,:,c) = (~D).*u_k(:,:,c);
end
subplot(1,2,2)
	imagesc(max(0,min(1,u_k/u_max)),[0 1])
	axis image off
	title('Image resultat','FontSize',20)
	if nb_canaux == 1
		colormap gray
	end
drawnow nocallbacks

% Initialisation de la frontiere de D :
delta_D = frontiere(D);
indices_delta_D = find(delta_D > 0);
nb_points_delta_D = length(indices_delta_D);

% Parametres :
t = 4;
T = 100;
lambda = 0; %parametre d'influence du terme de variance

% Tant que la frontiere de D n'est pas vide :
while nb_points_delta_D > 0

	% Pixel p de la frontiere de D tire selon ordre de priorité de Criminisi :
	indice_p = choix_p(indices_delta_D, D, u_k, t);
	[i_p,j_p] = ind2sub(size(D),indice_p);

	% Recherche du pixel q_chapeau :
	% [existe_q,bornes_V_p,bornes_V_q_chapeau] = d_min(i_p,j_p,u_k,D,t,T);
    % utilisation de la variante de d_min
    [existe_q,bornes_V_p,bornes_V_q_chapeau] = d_min_ameliorer(i_p,j_p,u_k,D,t,T);

	% S'il existe au moins un pixel q eligible :
	if existe_q

		% Rapiecage et mise a jour de D :
		[u_k,D] = rapiecage(bornes_V_p,bornes_V_q_chapeau,u_k,D);
        % Rapiecage version poisosn (copie des gradients) (pas efficace)
        % [u_k,D] = rapiecage_poisson(bornes_V_p, bornes_V_q_chapeau, u_k, D);

		% Mise a jour de la frontiere de D :
		delta_D = frontiere(D);
		indices_delta_D = find(delta_D > 0);
		nb_points_delta_D = length(indices_delta_D);

		% Affichage de l'image resultat :
		subplot(1,2,2)
		imagesc(max(0,min(1,u_k/u_max)),[0 1])
		axis image off
		title('Image resultat','FontSize',20)
		if nb_canaux == 1
			colormap gray
		end
		drawnow nocallbacks
	end
end

% lissage final avec eq de poisson : on colle les gradients de l'image
% initiale sur celle obtenue par rapiecage
[i_r, j_r] = find(D_init > 0);
i_min = min(i_r); 
i_max = max(i_r);
j_min = min(j_r); 
j_max = max(j_r);

r_global = u_0(i_min:i_max, j_min:j_max, :);
s_global = u_k(i_min:i_max, j_min:j_max, :);
masque_global = D_init(i_min:i_max, j_min:j_max);
interieur_global = find(masque_global == 1);

u_lisse = collage(r_global, s_global, interieur_global);
u_lisse = max(0, min(255, u_lisse));

u_finale = u_k;
for c = 1:size(u_k, 3)
    canal_f = u_finale(i_min:i_max, j_min:j_max, c);
    canal_l = u_lisse(:,:,c);
    canal_f(interieur_global) = canal_l(interieur_global);
    u_finale(i_min:i_max, j_min:j_max, c) = canal_f;
end

figure;
imagesc(max(0, min(1, u_finale/u_max)));
axis image off;
title('Hybridation TP5 + TP7 : Seamless Inpainting', 'FontSize', 20);