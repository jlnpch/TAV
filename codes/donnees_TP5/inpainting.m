function u_kp1 = inpainting(b,u_k,lambda,Dx,Dy,epsilon,D)
%DEBRUITAGE iteration débruitage par variation totale
    
    nb_pixels = size(u_k,1);
    W_domaine = spdiags(1-D(:),0,nb_pixels,nb_pixels);

    W_k = 1./sqrt((Dx*u_k).^2 + (Dy*u_k).^2 + epsilon);
    W_k = spdiags(W_k,0,nb_pixels,nb_pixels);
    
    A = W_domaine - lambda*(-Dx'*W_k*Dx-Dy'*W_k*Dy);
    b = W_domaine*b;

    u_kp1 = A\b;

end