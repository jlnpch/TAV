function [u_k, D] = rapiecage(bornes_V_p, bornes_V_q_chapeau, u_k, D)
% rapiecage : rempli V(p) avvec V(q_chapeau)


ip_min = bornes_V_p(1); 
ip_max = bornes_V_p(2);
jp_min = bornes_V_p(3); 
jp_max = bornes_V_p(4);
patch_p = u_k(ip_min:ip_max, jp_min:jp_max, :);

iq_min = bornes_V_q_chapeau(1); 
iq_max = bornes_V_q_chapeau(2);
jq_min = bornes_V_q_chapeau(3); 
jq_max = bornes_V_q_chapeau(4);
patch_q = u_k(iq_min:iq_max, jq_min:jq_max, :);

masque_D =logical(D(ip_min:ip_max, jp_min:jp_max));

nb_canaux = size(u_k, 3);
for c = 1:nb_canaux
    canal_p = patch_p(:,:,c);
    canal_q = patch_q(:,:,c);

    canal_p(masque_D) = canal_q(masque_D);
    patch_p(:,:,c) = canal_p;
end

u_k(ip_min:ip_max, jp_min:jp_max, :) = patch_p;
D(ip_min:ip_max, jp_min:jp_max) = 0;

end