function Y = TFCT(y, N, D, fenetre)
%TFCT Transformée de Fourrier à Court Terme

y_w = buffer(y,N,N-D,"nodelay");

if fenetre == "hann"
    y_w = y_w.*hann(size(y_w,1));
end

Y = fft(y_w);
Y = Y(1:(N/2)+1,:);

end