function [existe_q, bornes_V_p, bornes_V_q_chapeau] = d_min(i_p, j_p, u_k, D, t, T)
% d_min : Recherche le pixel q minimisant d(p,q)
[nb_lignes, nb_colonnes, ~] = size(u_k);

i_p_min = max(1, i_p - t);
i_p_max = min(nb_lignes, i_p + t);
j_p_min = max(1, j_p - t);
j_p_max = min(nb_colonnes, j_p + t);
bornes_V_p = [i_p_min, i_p_max, j_p_min, j_p_max];

R_p_mask = ~D(i_p_min:i_p_max, j_p_min:j_p_max);

i_F_min = max(1, i_p - T);
i_F_max = min(nb_lignes, i_p + T);
j_F_min = max(1, j_p - T);
j_F_max = min(nb_colonnes, j_p + T);

d_val_min = Inf;
i_q_chapeau = -1;
j_q_chapeau = -1;
existe_q = false;

patch_p = u_k(i_p_min:i_p_max, j_p_min:j_p_max, :);

for i_q = i_F_min : i_F_max
    for j_q = j_F_min : j_F_max

       
        if D(i_q, j_q) == 1
            continue;
        end

        i_q_min = i_q + (i_p_min - i_p);
        i_q_max = i_q + (i_p_max - i_p);
        j_q_min = j_q + (j_p_min - j_p);
        j_q_max = j_q + (j_p_max - j_p);

      
        if (i_q_min < 1 || i_q_max > nb_lignes || j_q_min < 1 || j_q_max > nb_colonnes)
            continue; 
        end

       
        if any(D(i_q_min:i_q_max, j_q_min:j_q_max), 'all')
            continue; 
        end

      
        patch_q = u_k(i_q_min:i_q_max, j_q_min:j_q_max, :);

        diff = (patch_p - patch_q).^2;
        diff = sum(diff, 3);
 
        d_p_q = sum(diff(R_p_mask)); 

        if d_p_q < d_val_min
            d_val_min = d_p_q;
            i_q_chapeau = i_q;
            j_q_chapeau = j_q;
            existe_q = true;
        end
    end
end

if existe_q
    bornes_V_q_chapeau = [i_q_chapeau + (i_p_min - i_p), ...
        i_q_chapeau + (i_p_max - i_p), ...
        j_q_chapeau + (j_p_min - j_p), ...
        j_q_chapeau + (j_p_max - j_p)];
else
    bornes_V_q_chapeau = [];
end

end