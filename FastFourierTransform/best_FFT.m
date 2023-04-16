diary metrics.out

img = imread('../Images/marina_bay.jpg');
file_name = "marina_bay_best_FFT";
filepath = '../Images';

% chosen parameters:
filter = 0; % low pass
resize = 1; % after
pooling = "avg_pool";
quant = 1000;
sigma = 2;

final_img = compress_FFT(img, filepath, file_name, sigma, quant, filter, pooling, resize);

figure
imshow(final_img)
