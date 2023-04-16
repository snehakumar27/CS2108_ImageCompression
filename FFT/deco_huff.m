function decoded_img = deco_huff(list)
    %list contains  {real_encoded, real_dict, imag_encoded, imag_dict, quant, block, resize, dim_processed, dim_original};
    real_encoded = list{1};
    real_dict = list{2};
    imag_encoded = list{3};
    imag_dict = list{4};
    quant = list{5};
    block = list{6};
    resize = list{7};
    dim_processed = list{8}; 
    dim_original = list{9}; 

    %Decode the huffman-encoded data 
    real_decoded = huffmandeco(double(real_encoded), real_dict);
    imag_decoded = huffmandeco(double(imag_encoded), imag_dict);

    %combine the real and imaginary parts 
    decoded = real_decoded + 1i*imag_decoded;
    %reshape it back to the processed layer size 
    decoded_magnitude = reshape(decoded, dim_processed);
    
    decoded_magnitude_10 = decoded_magnitude*quant;
    if block == "blocks"
        inv_func = @ifft2;
        final_img = blkproc(decoded_magnitude_10,[8 8], inv_func);
        decoded_img = real(uint8(final_img));
    else
    %perform inverse fft and convert it back to 8-bit integers 
        decoded_img = uint8(ifft2(decoded_magnitude_10));
    end

    %resize the image, if it should be performed after compression 
    if resize == 1
        decoded_img = imresize(decoded_img, dim_original);
    end 
    
end