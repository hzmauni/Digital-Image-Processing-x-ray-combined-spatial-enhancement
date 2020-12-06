%%%% STEP 1 %%%%
I = im2double(rgb2gray(imread('input.png')));
subplot(2,4,1);
imshow(I);
title('Figure(a)');

%%%% STEP 2, 3: LAPLACIAN FILTERING %%%%

% define positive laplacian filter
lf = [0 1 0 ; 1 -4 1 ; 0 1 0 ] ;

%pad array
J = padarray(I,[1 1]);  

%Apply filter
[row, col] = size(I);
Ic = zeros(row, col);

for i = 1:row
    for j = 1:col
       K = J(i:i+2, j:j+2);
       t = K .* lf;
       t = sum(t(:));
       Ic(i,j) = t;
    end
end
subplot(2,4,2);
imshow(Ic, []);
title('Figure(b)');

%Enhance Image
EI_lap = I-Ic;

subplot(2,4,3);
imshow(EI_lap);
title('Figure(c)');

%%%% STEP 4: SOBEL EDGE DETECTION %%%%

% define sobel operators
sy = [-1 -2 -1 ; 0 0 0 ; 1 2 1 ] ;
sx = [-1 0 1 ; -2 0 2 ; -1 0 1 ] ;

EI_sobel = zeros(row, col);
for i = 1:row 
    for j = 1:col
        Gx = sum(sum(sx.*J(i:i+2, j:j+2))); 
        Gy = sum(sum(sy.*J(i:i+2, j:j+2))); 
        d = sqrt(Gx.^2 + Gy.^2); 
        if d > 0.1
            EI_sobel(i,j) = d;  
        end
    end
end

subplot(2,4,4);
imshow(EI_sobel);
title('Figure(d)');

%%%% STEP 5: 5x5 AVERAGE FILTERING %%%%
L = padarray(EI_sobel,[2 2]);
EI_avg = zeros(row, col);
for i = 1:row
   for j = 1:col
       M = L(i:i+4, j:j+4);
       t = mean(M(:));
       EI_avg(i,j) = t;
   end
end
subplot(2,4,5);
imshow(EI_avg);
title('Figure(e)');

%%%% STEP 6: Product of step 3 and step 5 %%%%

EI_product = EI_lap .* EI_avg;
subplot(2,4,6);
imshow(EI_product);
title('Figure(f)');

%%%% STEP 7: Addition of step 1 and step 6 %%%%

EI_add = I + EI_product;
subplot(2,4,7);
imshow(EI_add);
title('Figure(g)');

%%%% STEP 8: Power law transformation %%%%

EI_pl = 1 .* (EI_add .^ 0.5);
subplot(2,4,8);
imshow(EI_pl);
title('Figure(h)');