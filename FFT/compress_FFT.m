function final = compress_FFT(img, filepath, image_name, thresh, quant, filter, block, resize)
    % img = ouput of imread; filepath, filename = string; thresh/sigma, quant = number 
    % filter = string; params; block, resize = string

    % check if given image is gray or color 
    if length(size(img)) < 3
        color = false; 
    else 
        color = true;
    end

    %perform the compression on each layer of the image 
    if color
        %if image is color, first convert it to YCbCr
        ycbcr_img = rgb2ycbcr(img);    

        %split the image into it's respective layers
        Y = ycbcr_img(:, :, 1);                 
        Cb = ycbcr_img(:, :, 2);
        Cr = ycbcr_img(:, :, 3); 

        %perform compression by huffman encoding and decoding 
        storage = whos('Y').bytes;
        save(strcat(filepath,'/',image_name,'_storage_matrix_','Y', '.mat'),'storage');

        Cb_new = deco_huff(enco_huff(Cb, filepath, 'Cb', image_name, thresh, quant, filter, block, resize));
        Cr_new = deco_huff(enco_huff(Cr, filepath, 'Cr', image_name, thresh, quant, filter, block, resize));

        %concatenate the compressed layers and convert it back to RGB
        merged_new = cat(3, Y, Cb_new, Cr_new); 
        final = ycbcr2rgb(merged_new);

    else
        %if image is gray (1 layer), perform compression only on 1 layer
        final = deco_huff(enco_huff(img, filepath, image_name, thresh, quant, filter, block, resize));
    end

    %save image in the specified file path with specified name
    imwrite(final, strcat(filepath,'/',image_name,'_compressed.jpg'));
end 
    