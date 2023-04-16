function [list] = enco_huff(layer, filepath, layer_name, image_name, thresh, quant, filter, block, resize) 
    %save dimension of original image (for resizing later)
    dim_ori = size(layer); 

    %% pre processing of layer if block != "none"
    if block == "avg_pool"
        pooling_factor = 2; 
        pooled_layer = imresize(layer, 1/pooling_factor, 'method', 'box');
        if resize == 0 % resize before
            layer = imresize(pooled_layer, dim_ori); 
        else 
            layer = pooled_layer; 
        end

    elseif block == "max_pool"
        pooling_factor = 2; 
        max_pool = @(x) max(x(:));
        pooled_layer = blkproc(layer, [pooling_factor pooling_factor], max_pool);
        if resize == 0
            layer = imresize(pooled_layer, dim_ori); 
        else 
            layer = pooled_layer; 
        end
    end

    %% if low_freq_pass, apply on layer before fft2 using gaussian filter
    if filter == 0
        layer = imgaussfilt(layer, thresh);
    end

    %% perform fft2 on the layer 
    f_img = fft2(layer);

    %get the size after any pooling/blocks
    dim_processed = size(f_img);

    %% if high_magnitude_pass, filter out frequencies with amplitude below the magnitude*threshold
    if filter == 1
        max_mag = max(max(abs(f_img)));
        f_img(abs(f_img) < (max_mag * thresh)) = 0;  %remove by setting to 0
    end
    
    %% Quantization 
    quant_img = floor(f_img/quant);

    %% Huffman Encoding, separate into real and imaginary parts
    real_f_img = real(quant_img);
    imag_f_img = imag(quant_img);
     
    % Generate Huffman dictionary and encode quantized magnitude FOR REAL
    real_symbols = unique(real_f_img(:));
    real_counts = hist(real_f_img(:), real_symbols);
    real_probabilities = real_counts/sum(real_counts);
    real_dict = huffmandict(real_symbols, real_probabilities);
    real_encoded = uint8(huffmanenco(real_f_img(:), real_dict));

    % Generate Huffman dictionary and encode quantized magnitude FOR IMAG
    imag_symbols = unique(imag_f_img(:));
    imag_counts = hist(imag_f_img(:), imag_symbols);
    imag_probabilities = imag_counts/sum(imag_counts);
    imag_dict = huffmandict(imag_symbols, imag_probabilities);
    imag_encoded = uint8(huffmanenco(imag_f_img(:), imag_dict));

    %% save the byte size
    storage = [whos('real_encoded').bytes, whos('imag_encoded').bytes, whos('real_dict').bytes, whos('imag_dict').bytes];
    save(strcat(filepath,'/',image_name,'_storage_matrix_',layer_name, '.mat'),'storage');

    list = {real_encoded, real_dict, imag_encoded, imag_dict, quant, block, resize, dim_processed, dim_ori};
end