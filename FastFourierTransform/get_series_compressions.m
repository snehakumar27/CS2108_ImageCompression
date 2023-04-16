function series = get_series_compressions(img, x_values, file_name, folder_name)
    % returns a matrix of size 4 by length(x_values)
    % each row is a different metric (refer to base_experiments to check)

    %% Retrieve Image Storage Space
    disp('bytes stored in order of : real_encoded, imag_encoded, real_dict, imag_dict')
    original_bytes = whos('img').bytes;
    disp(strcat('Original Image Matlab: ', string(original_bytes), ' bytes'));
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

    %% Loop through series of Compressed images to compare Compression ratio, MSE and SSIM:

    series_compressed = zeros(1,length(x_values));
    series_MSE = zeros(1,length(x_values));
    series_SSIM = zeros(1,length(x_values));

    ori = dir('../Images/marina_bay.jpg');
    for x = 1:length(x_values)
        % for each parameter-specific compressed sizes
        d = dir(strcat(folder_name,'/',file_name,'_',num2str(x_values(x)),'_compressed.jpg'));
        compression_ratio = (ori.bytes - d.bytes)/ori.bytes;
        disp(strcat(d.name, ': ', string(d.bytes), ' bytes, Compression ratio: ', string(compression_ratio)))
        series_compressed(x) = compression_ratio;
    end
    %series_compressed = (series_compressed-min(series_compressed))/(max(series_compressed)-min(series_compressed));

    % Retrieve series of MSE and SSIM
    for x = 1:length(x_values)
        % MSE %
        img_compressed = imread(strcat(folder_name,'/',file_name,'_',num2str(x_values(x)),'_compressed.jpg'));
        error = immse(img_compressed,img); 
        series_MSE(x) = error;
    
        % SSIM % 
        [ssimval,ssimmap] = ssim(img_compressed,img);
        series_SSIM(x) = ssimval;
    end

    %% perform normalisation on MSE and invert values (best value is now 1)
    %disp(min(series_MSE))
    %disp(max(series_MSE))
    %series_MSE = 1-((series_MSE-min(series_MSE))/(max(series_MSE)-min(series_MSE)));
    series_MSE = 1 - (series_MSE/(255.^2));

    %% take the average of all values to get an overall score
    %overall = round((series_storage + series_compressed + series_MSE + series_SSIM)/4,3);
    overall = round((series_compressed + series_MSE + series_SSIM)/3,3);

    series = cat(1, series_storage, series_compressed, series_MSE, series_SSIM, overall);
    
end