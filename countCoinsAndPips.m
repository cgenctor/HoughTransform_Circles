function [numCoins, numPips] = countCoinsAndPips(I)
%COUNTCOINSANDPIPS counts coins and pips in the input image
%   [numCoins, numPips] = countCoinsAndPips(I); 
%   gets a grayscale input
%   image and returns the number of coins and pips on dominoes in the
%   image. Also a figure is opened, visualizing the found coins and dices.

% [ numCoins , numPips ] = countCoinsAndPips(imread('coinsandpips/coinsandpips_1.png'))

%% Apply Gaussian smoothing to the input image.
sigma1 = 4.4; %4.4
sigma2 = 5;
sigma3 = 2.4;
Iblur1 = imgaussfilt(I,sigma1); 
Iblur2 = imgaussfilt(I,sigma2);  
Iblur3 = imgaussfilt(I,sigma3);
%% Perform edge detection.
BW = edge(Iblur3,'Canny',0.2102);

%% detect circles 
rmin1=115;
rmax1=167;
rmin2=180;
rmax2=250;
rmin3=18;
rmax3=45;
sen1 = 0.795;
sen2 = 0.803;

[centersM, radiiM] = imfindcircles(Iblur1,[rmin1 rmax1],'ObjectPolarity','dark','Sensitivity',sen1);
[centersL, radiiL] = imfindcircles(Iblur2,[rmin2 rmax2],'ObjectPolarity','dark','Sensitivity',sen2);
[centersSmall, radiiSmall] = imfindcircles(BW,[rmin3 rmax3]); % pips
%%
centers = [centersM ; centersL];
radiis = [radiiM; radiiL];
%bothcandr = [centers radiis];
[row,col] = size(centers);
k = 0;
for m = 1:(row+1)
    for n = (m+1):row
        if sqrt((centers(m,1)-centers(n,1))^2 + (centers(m,2)-centers(n,2))^2) < 35
            row1(k+1) = m;
            row2(k+1) = n;
            k = k+1;
        end
    end
end
for kk = 1:k
    if centers(row1(kk),1) > centers(row2(kk),1)
    centers(row1(kk),:) = [];
    radiis(row1(kk)) = [];
    elseif centers(row2(kk),1) > centers(row1(kk),1)
    centers(row2(kk),:) = [];
    radiis(row2(kk)) = [];
    else 
    msg = 'Error occurred.';
    error(msg)
    end
end
%% Return the numbers of coins and the number of pips
numCoins = size(centers,1);
numPips = size(centersSmall,1);    
%% Create a figure, show the image and visualize the detected coins and pips
figure()
imshow(I)
title( numCoins + " coins and " +numPips+ " pips" )
hold on;
viscircles(centers, radiis,'EdgeColor','b');
viscircles(centersSmall, radiiSmall,'EdgeColor','g');

end