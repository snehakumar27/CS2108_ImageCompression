%% This notebook uses SVD with the best parameters found from experiments to perform the compression
%final metrics (from console) save here 
diary metrics.txt
%% Original Image %% 
img = imread('../Images/marina_bay.jpg');

%% Best no Huffman Encoding %%
filepath = '../Images';
file_name = "marina_bay_SVD_compressed_best_no_encoding";

%define parameters (best from experiment)
thresh = 0.88;      %keep 12% of singular values 
block = "average";  %average pooling 
resize = 0;         %resize pooled layer before SVD
encoding = 0;       %no quantization & Huffman encoding 
quant = 0;          %quant step 0 since no quant & Huffman encoding tried here 

% perform compression
comp_no_huff = SVD_compress(img, file_name, filepath, thresh, block, resize, encoding, quant);

%Compression Ratio
disp('Best SVD Metrics')
ori = dir('../Images/marina_bay.jpg');
disp(strcat("Original size: ", num2str(ori.bytes)))
comp = dir(strcat(filepath,'/',file_name, '.jpg'));
disp(strcat("Compressed (no Huff) size: ", num2str(comp.bytes)))
compression_ratio = (ori.bytes - comp.bytes)/ori.bytes;
disp(strcat("Compression Ratio (no Huff): ", num2str(compression_ratio)))

%MSE
error = immse(comp_no_huff,img); 
disp(strcat("MSE (no Huff): ", num2str(error)));

%SSIM 
[ssimval,ssimmap] = ssim(comp_no_huff,img);
disp(strcat("SSIM (no Huff): ", num2str(ssimval)))

%% Best with Huffman Encoding %%
filepath = '../Images';
file_name = "marina_bay_SVD_compressed_best_with_encoding";

%define parameters (best from experiment)
thresh = 0.72;          %keep 28% of singular values 
block = "avg_pool";     %average pooling
resize = 1;             %resize after SVD
encoding = 1;           %with quantization & Huffman encoding 
quant = 5;              %quantization step of 5

% perform compression
comp_with_huff = SVD_compress(img, file_name, filepath, thresh, block, resize, encoding, quant);

%Compression Ratio
disp(strcat("Original size: ", num2str(ori.bytes)))
comp = dir(strcat(filepath,'/',file_name, '.jpg'));
disp(strcat("Compressed (with Huff) size: ", num2str(comp.bytes)))
compression_ratio = (ori.bytes - comp.bytes)/ori.bytes;
disp(strcat("Compression Ratio (with Huff): ", num2str(compression_ratio)))

%MSE
error = immse(comp_with_huff,img); 
disp(strcat("MSE (with Huff): ", num2str(error)))

%SSIM 
[ssimval,ssimmap] = ssim(comp_with_huff,img);
disp(strcat("SSIM (with Huff): ", num2str(ssimval))); 

%Storage Ratio 
d = dir(strcat(filepath,'/',file_name,'_storage_matrix_*.*'));
original_bytes = whos('img').bytes;
total_bytes = 0;
disp("Stored Encodings Sizes:")
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
disp(strcat("Storage Ratio (with Huff):", num2str(total_storage_ratio)))

%% Show Figures 
figure
subplot(1,3,1)
imshow(img)
title('Original Image')  

subplot(1,3,2)
imshow(comp_no_huff)
title('Compressed (no Huff) Image')  

subplot(1,3,3)
imshow(comp_with_huff)
title('Compressed (with Huff) Image')  

