%% FFT Experiments
img = imread('../Images/marina_bay.jpg');
file_name = "marina_bay";

%%
%%% High Pass Filter Experiments
filter = 1;

%% Testing Resize, Pooling and Quantisation

% set parameters
filepath = 'Results/high_magnitude_pass/test_resize_pool_quant';

quants = 400:400:3600; 
thresh = 0.004;

resize = 0; % resize set to before

pooling = ["none","avg_pool", "max_pool"];
metrics_agg = [];

for blk = 1:length(pooling)
    file_name_blks = strcat(file_name,'_before_',pooling(blk));
    for q = 1:length(quants) 
        disp(quants(q))
        file_name_specific = strcat(file_name_blks,'_',num2str(quants(q)));
        final = compress_FFT(img, filepath, file_name_specific, thresh, quants(q), filter, pooling(blk), resize);
    end
    metrics = get_series_compressions(img, quants, file_name_blks, filepath);
    metrics_agg = cat(3, metrics_agg, metrics);
end

% plot metrics for no pooling
metrics = metrics_agg(:,:, 1);
metrics_none = metrics;

figure
hold on 
plot(quants, metrics(2,:))
plot(quants, metrics(3,:))
plot(quants, metrics(4,:))
plot(quants, metrics(5,:),'LineWidth',2)
grid on;
xlabel('Quantization Step');
ylabel('Metric Value');
title('resize before, pool = "none"')
legend('compression ratio', 'MSE', 'SSIM', 'overall', 'Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_',file_name,'_before_pooling=none_metrics.jpg'))

% plot metrics for average pooling
metrics = metrics_agg(:,:, 2);
figure
hold on 
plot(quants, metrics(2,:))
plot(quants, metrics(3,:))
plot(quants, metrics(4,:))
plot(quants, metrics(5,:),'LineWidth',2)
grid on;
xlabel('Quantization Step');
ylabel('Metric Value');
title('resize before, pool = "avg pool"')
legend('compression ratio', 'MSE', 'SSIM', 'overall', 'Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_',file_name,'_before_pooling=avg_pool_metrics.jpg'))

% plot metrics for max pooling
metrics = metrics_agg(:,:, 3);
figure
hold on 
plot(quants, metrics(2,:))
plot(quants, metrics(3,:))
plot(quants, metrics(4,:))
plot(quants, metrics(5,:),'LineWidth',2)
grid on;
xlabel('Quantization Step');
ylabel('Metric Value');
title('resize before, pool = "max pool"')
legend('compression ratio', 'MSE', 'SSIM', 'overall', 'Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_',file_name,'_before_pooling=max_pool_metrics.jpg'))

% plot storage ratio for all three types of pooling
figure
hold on
plot(quants, metrics_none(1,:),'LineWidth',2, 'Linestyle', '-.') % no pooling
metrics = metrics_agg(:,:,2); % avg pooling
plot(quants, metrics(1,:), 'LineWidth',2, 'Linestyle', ':')
metrics = metrics_agg(:,:,3); % max pooling
plot(quants, metrics(1,:), 'LineWidth',2,'Linestyle', '--')
title('Storage Ratio for resizing before, high pass')
grid on;
xlabel('Quantization Step');
ylabel('Storage Ratio');
legend('none', 'average pool', 'max pool', 'Location', 'northeastout', 'FontSize', 8)
saveas(gcf,strcat(filepath,'/graph_', file_name,'_before_storage_ratio.jpg'))

% plot overall for all three types of pooling
figure
hold on
plot(quants, metrics_none(5,:),'LineWidth',2, 'Linestyle', '-.') 
metrics = metrics_agg(:,:,2);
plot(quants, metrics(5,:), 'LineWidth',2, 'Linestyle', ':')
metrics = metrics_agg(:,:,3); 
plot(quants, metrics(5,:), 'LineWidth',2,'Linestyle', '--')
title('Overall metrics for resizing before, high pass')
grid on;
xlabel('Quantization Step');
ylabel('Overall Score');
ylim([0.7 0.8])
legend('none', 'average pool', 'max pool', 'Location', 'northeastout', 'FontSize', 8)
saveas(gcf,strcat(filepath,'/graph_', file_name,'_before_overall_grouped.jpg'))

%%% Test for after
resize = 1; % resize set to after
metrics_agg = [];
pooling = ["avg_pool", "max_pool"];
for blk = 1:length(pooling)
    file_name_blks = strcat(file_name,'_after_',pooling(blk));
    for q = 1:length(quants) 
        disp(quants(q))
        file_name_specific = strcat(file_name_blks,'_',num2str(quants(q)));
        final = compress_FFT(img, filepath, file_name_specific, thresh, quants(q), filter, pooling(blk), resize);
    end
    metrics = get_series_compressions(img, quants, file_name_blks, filepath);
    metrics_agg = cat(3, metrics_agg, metrics);
end

% plot metrics for average pooling
metrics = metrics_agg(:,:, 1);
figure
hold on 
plot(quants, metrics(2,:))
plot(quants, metrics(3,:))
plot(quants, metrics(4,:))
plot(quants, metrics(5,:),'LineWidth',2)
grid on;
xlabel('Quantization Step');
ylabel('Metric Value');
title('resize after, pool = "avg pool"')
legend('compression ratio', 'MSE', 'SSIM', 'overall', 'Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_',file_name,'_after_pooling=avg_pool_metrics.jpg'))

% plot metrics for max pooling
metrics = metrics_agg(:,:, 2);
figure
hold on 
plot(quants, metrics(2,:))
plot(quants, metrics(3,:))
plot(quants, metrics(4,:))
plot(quants, metrics(5,:),'LineWidth',2)
grid on;
xlabel('Quantization Step');
ylabel('Metric Value');
title('resize after, pool = "max pool"')
legend('compression ratio', 'MSE', 'SSIM', 'overall', 'Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_',file_name,'_after_pooling=max_pool_metrics.jpg'))

% plot storage ratio on the same graph
figure
hold on
plot(quants, metrics_none(1,:),'LineWidth',2, 'Linestyle', '-.') 
metrics = metrics_agg(:,:,1); 
plot(quants, metrics(1,:), 'LineWidth',2, 'Linestyle', ':')
metrics = metrics_agg(:,:,2); 
plot(quants, metrics(1,:), 'LineWidth',2,'Linestyle', '--')
title('Storage Ratio for resizing after')
grid on;
xlabel('Quantization Step');
ylabel('Storage Ratio');
legend('none','average pool', 'max pool','Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_', file_name,'_after_storage_ratio.jpg'))

% plot overall for all three types of pooling
figure
hold on
plot(quants, metrics_none(5,:),'LineWidth',2, 'Linestyle', '-.')
metrics = metrics_agg(:,:,1);
plot(quants, metrics(5,:), 'LineWidth',2, 'Linestyle', ':')
metrics = metrics_agg(:,:,2); 
plot(quants, metrics(5,:), 'LineWidth',2,'Linestyle', '--')
title('Overall metric for resizing after')
grid on;
xlabel('Quantization Step');
ylabel('Overall Score');
ylim([0.7 0.8])
legend('none', 'average pool', 'max pool', 'Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_', file_name,'_after_overall_grouped.jpg'))

%% Testing threshold range for chosen parameters 

% set parameters
filepath = 'Results/high_magnitude_pass/test_thresh';

% chosen parameters:
quant = 1500;
resize = 1; % resize set to after
pooling = ["max_pool"];

thresh = 0.002:0.001:0.01; % to test threshold

metrics_agg = [];

for blk = 1:length(pooling)
    file_name_blks = strcat(file_name,'_after_',pooling(blk));
    for k = 1:length(thresh) 
        disp(thresh(k))
        file_name_specific = strcat(file_name_blks,'_',num2str(thresh(k)));
        final = compress_FFT(img, filepath, file_name_specific, thresh(k), quant, filter, pooling(blk), resize);
    end
    metrics = get_series_compressions(img, thresh, file_name_blks, filepath);
    metrics_agg = cat(3, metrics_agg, metrics);
end

% plot metrics (for average pooling)
metrics = metrics_agg(:,:, 1);
figure
hold on 
plot(thresh, metrics(2,:))
plot(thresh, metrics(3,:))
plot(thresh, metrics(4,:))
plot(thresh, metrics(5,:),'LineWidth',2,'Linestyle', '-.')
grid on;
xlabel('Threshold Proportion');
ylabel('Metric Value');
title('Final Perceived Quality Metrics for high pass')
legend('compression ratio', 'MSE', 'SSIM', 'overall', 'Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_',file_name,'_after_pooling=avg_pool_metrics.jpg'))

% plot storage ratio 
figure
hold on
metrics = metrics_agg(:,:,1);
plot(thresh, metrics(1,:), 'LineWidth',2, 'Linestyle', '-.')
title('Final Storage Ratio for high pass')
grid on;
xlabel('Threshold Proportion');
ylabel('Storage Ratio');
legend('average pool', 'Location', 'northeastout', 'FontSize', 8)
saveas(gcf,strcat(filepath,'/graph_', file_name,'_after_storage_ratio.jpg'))


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Low Pass Filter Experiments
filter = 0;

% Test for low pass filter and resize type, varying quant

% set parameters
filepath = 'Results/low_freq_pass/test_resize_pool_quant';

quants = 400:400:3600; 
sigma = 0.004;
pooling = ["none","avg_pool", "max_pool"];

resize = 0; % resize set to before
metrics_agg = [];

for blk = 1:length(pooling)
    file_name_blks = strcat(file_name,'_before_',pooling(blk));
    disp(file_name_blks)
    for q = 1:length(quants) 
        disp(quants(q))
        file_name_specific = strcat(file_name_blks,'_',num2str(quants(q)));
        final = compress_FFT(img, filepath, file_name_specific, sigma, quants(q), filter, pooling(blk), resize);
    end
    metrics = get_series_compressions(img, quants, file_name_blks, filepath);
    metrics_agg = cat(3, metrics_agg, metrics);
end

% plot metrics for no pooling
metrics = metrics_agg(:,:, 1);
metrics_none = metrics;
metrics_before = metrics_agg;

figure
hold on 
plot(quants, metrics(2,:))
plot(quants, metrics(3,:))
plot(quants, metrics(4,:))
plot(quants, metrics(5,:),'LineWidth',2)
grid on;
xlabel('Quantization Step');
ylabel('Metric Value');
title('resize before, pool = "none"')
legend('compression ratio', 'MSE', 'SSIM', 'overall', 'Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_',file_name,'_before_pooling=none_metrics.jpg'))


% plot metrics for average pooling
metrics = metrics_agg(:,:, 2);
figure
hold on 
plot(quants, metrics(2,:))
plot(quants, metrics(3,:))
plot(quants, metrics(4,:))
plot(quants, metrics(5,:),'LineWidth',2)
grid on;
xlabel('Quantization Step');
ylabel('Metric Value');
title('resize before, pool = "avg pool"')
legend('compression ratio', 'MSE', 'SSIM', 'overall', 'Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_',file_name,'_before_pooling=avg_pool_metrics.jpg'))


% plot metrics for max pooling
metrics = metrics_agg(:,:, 3);
figure
hold on 
plot(quants, metrics(2,:))
plot(quants, metrics(3,:))
plot(quants, metrics(4,:))
plot(quants, metrics(5,:),'LineWidth',2)
grid on;
xlabel('Quantization Step');
ylabel('Metric Value');
title('resize before, pool = "max pool"')
legend('compression ratio', 'MSE', 'SSIM', 'overall', 'Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_',file_name,'_before_pooling=max_pool_metrics.jpg'))

% plot storage ratio on the same graph
figure
hold on
plot(quants, metrics_none(1,:),'LineWidth', 2, 'Linestyle', '-.') 
metrics = metrics_agg(:,:,2);
plot(quants, metrics(1,:),'LineWidth',2, 'Linestyle', ':')
metrics = metrics_agg(:,:,3);
plot(quants, metrics(1,:),'LineWidth',2, 'Linestyle', '--')
title('Storage Ratio for resizing before, low pass')
grid on;
xlabel('Quantization Step');
ylabel('Storage Ratio');
legend('none','average pool', 'max pool','Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_', file_name,'_before_storage_ratio.jpg'))

% plot overall for all three types on the same graph
figure
hold on
plot(quants, metrics_none(5,:),'LineWidth',2, 'Linestyle', '-.') 
metrics = metrics_agg(:,:,2); 
plot(quants, metrics(5,:), 'LineWidth',2, 'Linestyle', ':')
metrics = metrics_agg(:,:,3);
plot(quants, metrics(5,:), 'LineWidth',2,'Linestyle', '--')
title('Overall Metric for resizing before, low pass')
grid on;
xlabel('Quantization Step');
ylabel('Overall Score');
ylim([0.7 0.8])
legend('none', 'average pool', 'max pool', 'Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_', file_name,'_before_overall_grouped.jpg'))


%%% Test for after
resize = 1; % resize set to after
metrics_agg = [];
pooling = ["avg_pool", "max_pool"];
for blk = 1:length(pooling)
    file_name_blks = strcat(file_name,'_after_',pooling(blk));
    for q = 1:length(quants) 
        disp(quants(q))
        file_name_specific = strcat(file_name_blks,'_',num2str(quants(q)));
        final = compress_FFT(img, filepath, file_name_specific, sigma, quants(q), filter, pooling(blk), resize);
    end
    metrics = get_series_compressions(img, quants, file_name_blks, filepath);
    metrics_agg = cat(3, metrics_agg, metrics);
end

% plot metrics for average pooling
metrics = metrics_agg(:,:, 1);
figure
hold on 
plot(quants, metrics(2,:))
plot(quants, metrics(3,:))
plot(quants, metrics(4,:))
plot(quants, metrics(5,:),'LineWidth',2)
grid on;
xlabel('Quantization Step');
ylabel('Metric Value');
title('resize after, pool = "avg pool"')
legend('compression ratio', 'MSE', 'SSIM', 'overall', 'Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_',file_name,'_after_pooling=avg_pool_metrics.jpg'))

% plot metrics for max pooling
metrics = metrics_agg(:,:, 2);
figure
hold on 
plot(quants, metrics(2,:))
plot(quants, metrics(3,:))
plot(quants, metrics(4,:))
plot(quants, metrics(5,:),'LineWidth',2)
grid on;
xlabel('Quantization Step');
ylabel('Metric Value');
title('resize after, pool = "max pool"')
legend('compression ratio', 'MSE', 'SSIM', 'overall', 'Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_',file_name,'_after_pooling=max_pool_metrics.jpg'))

% plot storage ratio on the same graph
figure
hold on
plot(quants, metrics_none(1,:),'LineWidth',2, 'Linestyle', '-.') 
metrics = metrics_agg(:,:,1); 
plot(quants, metrics(1,:), 'LineWidth',2, 'Linestyle', ':')
metrics = metrics_agg(:,:,2);
plot(quants, metrics(1,:), 'LineWidth',2,'Linestyle', '--')
title('Storage Ratio for resizing after, low pass')
grid on;
xlabel('Quantization Step');
ylabel('Storage Ratio');
legend('none','average pool', 'max pool','Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_', file_name,'_after_storage_ratio.jpg'))

% plot overall for all three types of pooling on the same graph
figure
hold on
plot(quants, metrics_none(5,:),'LineWidth',2, 'Linestyle', '-.') 
metrics = metrics_agg(:,:,1);
plot(quants, metrics(5,:), 'LineWidth',2, 'Linestyle', ':')
metrics = metrics_agg(:,:,2);
plot(quants, metrics(5,:), 'LineWidth',2,'Linestyle', '--')
title('Overall metric for resizing after, low pass')
grid on;
xlabel('Quantization Step');
ylabel('Overall Score');
ylim([0.7 0.8])
legend('none', 'average pool', 'max pool', 'Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_', file_name,'_after_overall_grouped.jpg'))


%% Testing Resize with chosen parameters varying sigma

% set parameters
filepath = 'Results/low_freq_pass/test_thresh';

% chosen parameters:
resize = 1; % after
quant = 1500;
pooling = ["max_pool"];

sigmas = 1:1:10; % to test sigma

metrics_agg = [];

for blk = 1:length(pooling)
    file_name_blks = strcat(file_name,'_after_',pooling(blk));
    for k = 1:length(sigmas) 
        disp(sigmas(k))
        file_name_specific = strcat(file_name_blks,'_',num2str(sigmas(k)));
        final = compress_FFT(img, filepath, file_name_specific, sigmas(k), quant, filter, pooling(blk), resize);
    end
    metrics = get_series_compressions(img, sigmas, file_name_blks, filepath);
    metrics_agg = cat(3, metrics_agg, metrics);
end

% plot metrics for average pooling
metrics = metrics_agg(:,:, 1);
figure
hold on 
plot(sigmas, metrics(2,:))
plot(sigmas, metrics(3,:))
plot(sigmas, metrics(4,:))
plot(sigmas, metrics(5,:),'LineWidth',2,'Linestyle', '-.')
grid on;
xlabel('Sigma');
ylabel('Metric Value');
title('Final Perceived Quality Metrics for low pass')
legend('compression ratio', 'MSE', 'SSIM', 'overall', 'Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_',file_name,'_after_blocks=avg_pool_metrics.jpg'))

% plot storage ratio separately
figure
hold on
metrics = metrics_agg(:,:,1);
plot(sigmas, metrics(1,:), 'LineWidth',2, 'Linestyle', '-.')
title('Final Storage Ratio for low pass')
grid on;
xlabel('Sigma');
ylabel('Storage Ratio');
legend('avg pool','Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_', file_name,'_after_storage_ratio.jpg'))