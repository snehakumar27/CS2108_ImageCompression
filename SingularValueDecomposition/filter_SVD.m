function new_layer = filter_SVD(layer, image_name, filepath, layer_name, thresh, block, resize, encoding, quant)
    dim_original = size(layer);

    if block == "avg_pool"
        pooling_factor = 8; 
        layer = imresize(layer, 1/pooling_factor, 'method', 'box');
        if resize == 0
            layer = imresize(layer, dim_original);
        end
    elseif block == "max_pool"
        pooling_factor = 8; 
        max_pool = @(x) max(x(:));
        layer = blkproc(layer, [pooling_factor pooling_factor], max_pool);
        if resize == 0
            layer = imresize(layer, dim_original);
        end
    end

    [U, S, V] = svd(double(layer));
    k = round((1-thresh) * min(size(S))); 
    new_U = U(:, 1:k);
    new_S = S(1:k, 1:k); 
    new_V = V(:, 1:k);

    if encoding == 0
        new_layer = uint8(new_U * new_S * new_V');
    else 
        img_compressed = new_U*new_S*new_V';
        img_quantized = round(img_compressed/quant);

        symbols = unique(img_quantized(:));
        counts = hist(img_quantized(:),symbols);
        probabilities = counts/sum(counts);
        dict = huffmandict(symbols,probabilities);

        img_encoded = huffmanenco(img_quantized(:),dict);

        % save the byte size
        storage = [whos('img_encoded').bytes, whos('dict').bytes];
        save(strcat(filepath,'/',image_name,'_storage_matrix_',layer_name, '.mat'),'storage');

        img_decoded = huffmandeco(img_encoded,dict);

        img_decoded = reshape(img_decoded, size(img_compressed));
        new_layer = img_decoded*quant;
    end
    
    if resize == 1
        new_layer = imresize(new_layer, dim_original);
    end
    
