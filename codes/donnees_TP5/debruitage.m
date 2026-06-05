function u_kp1 = debruitage(b,u_k,lambda,Dx,Dy,epsilon)
%DEBRUITAGE iteration débruitage par variation totale
    
    nb_pixels = size(u_k,1);
    I_n = speye(nb_pixels);

    W_k = 1./sqrt((Dx*u_k).^2 + (Dy*u_k).^2 + epsilon);
    W_k = spdiags(W_k,0,nb_pixels,nb_pixels);
    
    A = I_n - lambda*(-Dx'*W_k*Dx-Dy'*W_k*Dy);

    u_kp1 = A\b;

end