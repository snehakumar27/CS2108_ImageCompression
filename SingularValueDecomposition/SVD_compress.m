function compressed_img = SVD_compress(img, image_name, folder_name, thresh, block, resize, encoding, quant)

%convert image to YCbCr
img_ycbcr = rgb2ycbcr(img);

%separate out the layers 
layer_1 = img_ycbcr(:,:,1);
layer_2 = img_ycbcr(:,:,2);
layer_3 = img_ycbcr(:,:,3);

if encoding == 1
    storage = whos('layer_1').bytes;
    save(strcat(folder_name,'/',image_name,'_storage_matrix_','Y', '.mat'),'storage');
end

new_layer_2 = filter_SVD(layer_2, image_name, folder_name, 'Cb', thresh, block, resize, encoding, quant); 
new_layer_3 = filter_SVD(layer_3, image_name, folder_name, 'Cr', thresh, block, resize, encoding, quant); 

comp_img = cat(3, layer_1, new_layer_2, new_layer_3);
compressed_img = ycbcr2rgb(comp_img);

imwrite(compressed_img, strcat(folder_name, '/', image_name,'.jpg'))

