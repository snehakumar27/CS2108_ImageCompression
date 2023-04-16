%% This notebook uses FFT with the best parameters found from experiments to perform the compression
%final metrics (from console) save here 
diary metrics.txt

%% Original Image %%
img = imread('../Images/marina_bay.jpg');

%% Best FFT Parameters
file_name = "marina_bay_best_FFT";
filepath = '../Images';

%define parameters (best from experiment)
filter = 0;             % low frequency pass
pooling = "max_pool";   %average pooling
resize = 1;             % resize after huffman decoding
quant = 1500;           % quantization step 
sigma = 2;              % standard deviation of Gaussian filter 

%perform compression 
final_img = compress_FFT(img, filepath, file_name, sigma, quant, filter, pooling, resize);


%Compression Ratio
disp('Best FFT Metrics')
ori = dir('../Images/marina_bay.jpg');
disp(strcat("Original size: ", num2str(ori.bytes)))
comp = dir(strcat(filepath,'/',file_name,'_compressed.jpg'));
disp(strcat("Compressed size: ", num2str(comp.bytes)))
compression_ratio = (ori.bytes - comp.bytes)/ori.bytes;
disp(strcat("Compression Ratio: ", num2str(compression_ratio)))

%MSE
error = immse(final_img,img); 
disp(strcat("MSE: ", num2str(error)))

%SSIM 
[ssimval,ssimmap] = ssim(final_img,img);
disp(strcat("SSIM: ", num2str(ssimval))); 

%Storage Ratio 
d = dir(strcat(filepath,'/',file_name,'_storage_matrix_*.*'));
original_bytes = whos('img').bytes;
total_bytes = 0;
disp("Stored Encodings Sizes: ")
for k = 1 : length(d)
    list = load(strcat(filepath,'/',d(k).name));
    % convert list (in struct type) to cell type and access first index to get array
    list = struct2cell(list);
    list = list{1};  
    disp(list)
    
    % loop through list to sum up bytes
    for index = 1 : length(list)
        total_bytes = total_bytes + list(index);
    end 
end
disp(strcat('Total Storage: ', string(total_bytes), ' bytes, ', 'Storage Reduction: ', string(original_bytes - total_bytes), ' bytes'))
total_storage_ratio = (original_bytes - total_bytes)/original_bytes;
disp(strcat("Storage Ratio: ", num2str(total_storage_ratio)))



%% Show Figures 
figure
subplot(1,2,1)
imshow(img)
title('Original Image')  

subplot(1,2,2)
imshow(final_img)
title('Compressed Image')  
