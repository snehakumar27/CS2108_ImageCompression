function series = get_series_compressions(img, x_values, file_name, folder_name, encoding)
    % returns a matrix of size 4 by length(x_values)
    % each row is a different metric (refer to base_experiments to check)

    %% Original image size (saved in MATLAB to compare bytes)
    original_bytes = whos('img').bytes;
    disp(strcat('Original Image Matlab: ', string(original_bytes), ' bytes'));

    %% Loop through series of compressed images to compare compressed ratio, MSE and SSIM:

    series_compressed = zeros(1,length(x_values));
    series_MSE = zeros(1,length(x_values));
    series_SSIM = zeros(1,length(x_values));

    for x = 1:length(x_values)
        % for each parameter-specific compressed sizes
        d = dir(strcat(folder_name,'/',file_name,'_',num2str(x_values(x)), '.jpg'));
        disp(original_bytes)
        disp(d.bytes)
        compression_ratio = (original_bytes - d.bytes)/original_bytes;
        disp(strcat(d.name, ': ', string(d.bytes), ' bytes, Compression ratio: ', string(compression_ratio)))
        series_compressed(x) = compression_ratio;
    end

    % Retrieve series of MSE and SSIM
    for x = 1:length(x_values)
        % MSE %
        compressed_img = imread(strcat(folder_name,'/',file_name,'_',num2str(x_values(x)), '.jpg'));

        error = immse(compressed_img,img); 
        series_MSE(x) = error;
    
        % SSIM % 
        [ssimval,ssimmap] = ssim(compressed_img,img);
        series_SSIM(x) = ssimval;
    end

    %% perform normalisation on MSE and invert values (best value is now 1)
    
    %series_MSE = 1-((series_MSE-min(series_MSE))/(max(series_MSE)-min(series_MSE)));
    series_MSE = 1 - (series_MSE/(255.^2));
    %% take the average of all values to get an overall score
    overall = round((series_compressed + series_MSE + series_SSIM)/3,3);

    %% Retrieve Image Storage Space
    if encoding == 1
        disp('bytes stored in order of : encoded, dict')
        series_storage = zeros(1,length(x_values)); % in order of x_values

        for x = 1:length(x_values)
            % for each parameter-specific compressed sizes
            d = dir(strcat(folder_name,'/',file_name,'_',num2str(x_values(x)),'_storage_matrix_*.*'));
            total_bytes = 0;
            for k = 1 : length(d)
                list = load(strcat(folder_name,'/',d(k).name));
                % convert list (in struct type) to cell type and access first index to get array
                list = struct2cell(list);
                list = list{1};  
                disp(d(k).name)
                disp(list)
    
                % loop through list to sum up bytes
                for index = 1 : length(list)
                    total_bytes = total_bytes + list(index);
                end
            end
            disp(strcat('TOTAL: ', string(total_bytes), ' bytes, ', 'DIFFERENCE: ', string(original_bytes - total_bytes)))
            total_storage_ratio = (original_bytes - total_bytes)/original_bytes;
            series_storage(x) = total_storage_ratio;
        end
        
        disp(' ')
    end

    %% return 
    if encoding == 1
        series = cat(1, series_compressed, series_MSE, series_SSIM, overall, series_storage);
    else 
        series = cat(1, series_compressed, series_MSE, series_SSIM, overall); 
    end
end