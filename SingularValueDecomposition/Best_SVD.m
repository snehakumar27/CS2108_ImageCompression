%% This notebook uses SVD with the best parameters found from experiments to perform the compression
%% Original Image %% 
img = imread('../Images/marina_bay.jpg');
original_bytes = whos('img').bytes;

%% Best no Huffman Encoding %%
%define parameters (best from experiment)
filepath = '../Images';
file_name = "marina_bay_SVD_compressed_best_no_encoding";
thresh = 0.8;   %keep 20% of singular values 
block = "none"; %no pooling
resize = 0;     % (resizing order doesn't matter for no pooling)
encoding = 0;   %no quantization & Huffman encoding 
quant = 0;      %quant step 0 since no quant & Huffman encoding tried here 

% perform compression
comp_no_huff = SVD_compress(img, file_name, filepath, thresh, block, resize, encoding, quant);

%Compression Ratio
disp(strcat("Original size:", original_bytes))
comp_no_huff_bytes = whos('comp_no_huff').bytes;
disp(strcat("Compressed (no Huff) size:", comp_no_huff_bytes));
compression_ratio = (original_bytes - comp_no_huff_bytes)/original_bytes;
disp("Compression Ratio (no Huff):", compression_ratio);

%MSE
error = immse(comp_no_huff,img); 
disp("MSE (no Huff): ", error); 

%SSIM 
[ssimval,ssimmap] = ssim(comp_no_huff,img);
disp("SSIM (no Huff): ", ssimval); 

%% Best with Huffman Encoding %%
%define parameters (best from experiment)
filepath = '../Images';
file_name = "marina_bay_SVD_compressed_best_with_encoding";
thresh = 0.75;          %keep 25% of singular values 
block = "avg_pool";     %average pooling
resize = 1;             %resize after SVD
encoding = 1;           %with quantization & Huffman encoding 
quant = 5;              %quantization step of 5

% perform compression
comp_with_huff = SVD_compress(img, file_name, filepath, thresh, block, resize, encoding, quant);

%Compression Ratio
disp(strcat("Original size:", original_bytes))
comp_with_huff_bytes = whos('comp_with_huff').bytes;
disp(strcat("Compressed (with Huff) size:", comp_with_huff_bytes));
compression_ratio = (original_bytes - comp_with_huff_bytes)/original_bytes;
disp("Compression Ratio (with Huff):", compression_ratio);

%MSE
error = immse(comp_with_huff,img); 
disp("MSE (with Huff): ", error); 

%SSIM 
[ssimval,ssimmap] = ssim(comp_with_huff,img);
disp("SSIM (with Huff): ", ssimval); 

%Storage Ratio 
d = dir(strcat(folder_name,'/',file_name,'_storage_matrix_*.*'));



