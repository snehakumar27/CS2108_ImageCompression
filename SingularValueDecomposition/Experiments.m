%% SVD Experiments 
img = imread('../ImageData/marina_bay.jpg');

%% Testing Resize before (0, before SVD)

%set parameters 
filepath = 'Results/test_resize';
file_name = "marina_bay";

%range of parameters tested 
thresholds = 0.64:0.04:0.96;     %series of threshold values 
blocks = ["none", "avg_pool", "max_pool"];       %series of block types

%%% Test for before
resize = 0; % resize set to before
encoding = 0; %no quant & Huffman encoding tried here 
quant = 0;  %quant step 0 since no quant & Huffman encoding tried here 
metrics_agg = [];

for blk = 1:length(blocks)
    file_name_blks = strcat(file_name, '_before_', blocks(blk));
    for k = 1:length(thresholds) 
        disp(thresholds(k)) % to check progress of code
        file_name_specific = strcat(file_name_blks,'_',num2str(thresholds(k)));
        final = SVD_compress(img, file_name_specific, filepath, thresholds(k), blocks(blk), resize, encoding, quant);
    end
    metrics = get_series_compressions(img, thresholds, file_name_blks, filepath, encoding);
    metrics_agg = cat(3, metrics_agg, metrics);
end

% plot metrics for blocks = "none"
metrics = metrics_agg(:,:, 1);

figure
hold on 
plot(thresholds, metrics(1,:))
plot(thresholds, metrics(2,:))
plot(thresholds, metrics(3,:))
plot(thresholds, metrics(4,:),'LineWidth',2)
grid on;
xlabel('Threshold Proportion');
ylabel('Metric Value');
yticks(0:0.05:1)
title('resize before, blocks = "none"')
legend('compression ratio', 'MSE', 'SSIM', 'overall', 'Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_',file_name,'_before_blocks=none_metrics.jpg'))

% plot metrics for blocks = "avg_pool"
metrics = metrics_agg(:,:, 2);

figure
hold on 
plot(thresholds, metrics(1,:))
plot(thresholds, metrics(2,:))
plot(thresholds, metrics(3,:))
plot(thresholds, metrics(4,:),'LineWidth',2)
grid on;
xlabel('Threshold Proportion');
ylabel('Metric Value');
yticks(0:0.05:1)
title('resize before, blocks = "avg pool"')
legend('compression ratio', 'MSE', 'SSIM', 'overall', 'Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_',file_name,'_before_blocks=avg_pool_metrics.jpg'))

% plot metrics for blocks = "max_pool"
metrics = metrics_agg(:,:, 3);

figure
hold on 
plot(thresholds, metrics(1,:))
plot(thresholds, metrics(2,:))
plot(thresholds, metrics(3,:))
plot(thresholds, metrics(4,:),'LineWidth',2)
grid on;
xlabel('Threshold Proportion');
ylabel('Metric Value');
yticks(0:0.05:1)
title('resize before, blocks = "max pool"')
legend('compression ratio', 'MSE', 'SSIM', 'overall', 'Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_',file_name,'_before_blocks=max_pool_metrics.jpg'))

% plot overall for all three types on the same graph
figure
hold on
metrics = metrics_agg(:,:,1);
plot(thresholds, metrics(4,:),'LineWidth',2, 'Linestyle', '-.') % blocks = "none"
metrics = metrics_agg(:,:,2); % blocks = "avg_pool"
plot(thresholds, metrics(4,:), 'LineWidth',2, 'Linestyle', ':')
metrics = metrics_agg(:,:,3); % blocks = "max_pool"
plot(thresholds, metrics(4,:), 'LineWidth',2,'Linestyle', '--')
title('Overall metric for resizing before')
grid on;
xlabel('Threshold Proportion');
ylabel('Overall');
ylim([0.88 1])
legend('none', 'average pool', 'max pool', 'Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_', file_name,'_before_overall_grouped.jpg'))



%% Test for resize after SVD (1, after SVD)
resize = 1; % resize set to before
metrics_agg = [];
encoding = 0; %no quant & Huffman encoding tried here 
quant = 0;  %quant step 0 since no quant & Huffman encoding tried here 

for blk = 1:length(blocks)
    file_name_blks = strcat(file_name, '_after_', blocks(blk));
    for k = 1:length(thresholds) 
        disp(thresholds(k)) % to check progress of code
        file_name_specific = strcat(file_name_blks,'_',num2str(thresholds(k)));
        final = SVD_compress(img, file_name_specific, filepath, thresholds(k), blocks(blk), resize, encoding, quant);
    end
    metrics = get_series_compressions(img, thresholds, file_name_blks, filepath, encoding);
    metrics_agg = cat(3, metrics_agg, metrics);
end


% plot metrics for blocks = "none"
metrics = metrics_agg(:,:, 1);

figure
hold on 
plot(thresholds, metrics(1,:))
plot(thresholds, metrics(2,:))
plot(thresholds, metrics(3,:))
plot(thresholds, metrics(4,:),'LineWidth',2)
grid on;
xlabel('Threshold Proportion');
ylabel('Metric Value');
yticks(0:0.05:1)
title('resize after, blocks = "none"')
legend('compression ratio', 'MSE', 'SSIM', 'overall', 'Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_',file_name,'_after_blocks=none_metrics.jpg'))

% plot metrics for blocks = "none"
metrics = metrics_agg(:,:, 2);

figure
hold on 
plot(thresholds, metrics(1,:))
plot(thresholds, metrics(2,:))
plot(thresholds, metrics(3,:))
plot(thresholds, metrics(4,:),'LineWidth',2)
grid on;
xlabel('Threshold Proportion');
ylabel('Metric Value');
yticks(0:0.05:1)
title('resize after, blocks = "avg pool"')
legend('compression ratio', 'MSE', 'SSIM', 'overall', 'Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_',file_name,'_after_blocks=avg_pool_metrics.jpg'))


% plot metrics for blocks = "max_pool"
metrics = metrics_agg(:,:, 3);

figure
hold on 
plot(thresholds, metrics(1,:))
plot(thresholds, metrics(2,:))
plot(thresholds, metrics(3,:))
plot(thresholds, metrics(4,:),'LineWidth',2)
grid on;
xlabel('Threshold Proportion');
ylabel('Metric Value');
yticks(0:0.05:1)
title('resize after, blocks = "max pool"')
legend('compression ratio', 'MSE', 'SSIM', 'overall', 'Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_',file_name,'_after_blocks=max_pool_metrics.jpg'))

% plot overall for all three types on the same graph
figure
hold on
metrics = metrics_agg(:,:,1);
plot(thresholds, metrics(4,:),'LineWidth',2, 'Linestyle', '-.') % blocks = "none"
metrics = metrics_agg(:,:,2); % blocks = "avg_pool"
plot(thresholds, metrics(4,:), 'LineWidth',2, 'Linestyle', ':')
metrics = metrics_agg(:,:,3); % blocks = "max_pool"
plot(thresholds, metrics(4,:), 'LineWidth',2,'Linestyle', '--')
title('Overall metric for resizing after')
grid on;
xlabel('Threshold Proportion');
ylabel('Overall');
ylim([0.88 1])
legend('none', 'average pool', 'max pool', 'Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_', file_name,'_after_overall_grouped.jpg'))


%% Test with Huffman Encoding with Resizing Before 
%set parameters 
filepath = 'Results/test_huffman_quant/thresholds';
file_name = "marina_bay";

%range of parameters tested 
thresholds = 0.64:0.04:0.96;     %series of threshold values 
blocks = ["none", "avg_pool", "max_pool"];       %series of block types

%%% Test for resizing before with Huffman
resize = 0; % resize set to before
metrics_agg = [];
encoding = 1;
quant = 5;  

for blk = 1:length(blocks)
    file_name_blks = strcat(file_name, '_before_', blocks(blk));
    for k = 1:length(thresholds) 
        disp(thresholds(k)) % to check progress of code
        file_name_specific = strcat(file_name_blks,'_',num2str(thresholds(k)));
        final = SVD_compress(img, file_name_specific, filepath, thresholds(k), blocks(blk), resize, encoding, quant);
    end
    metrics = get_series_compressions(img, thresholds, file_name_blks, filepath, encoding);
    metrics_agg = cat(3, metrics_agg, metrics);
end

% plot metrics for blocks = "none"
metrics = metrics_agg(:,:, 1);

figure
hold on 
plot(thresholds, metrics(1,:))
plot(thresholds, metrics(2,:))
plot(thresholds, metrics(3,:))
plot(thresholds, metrics(4,:),'LineWidth',2)
grid on;
xlabel('Threshold Proportion');
ylabel('Metric Value');
yticks(0:0.05:1)
title('resize before with enco, blocks = "none"')
legend('compression ratio', 'MSE', 'SSIM', 'overall', 'Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_',file_name,'_before_enco_blocks=none_metrics.jpg'))

% plot storage ratio separately
figure
plot(thresholds, metrics(5,:))
grid on;
xlabel('Threshold Proportion')
ylabel('Storage Ratio')
title('Resize before with Encoding, blocks = "none"')
legend('storage ratio')
saveas(gcf,strcat(filepath,'/graph_', file_name,'_before_enco_blocks=none_storage_ratio.jpg'))


% plot metrics for blocks = "none"
metrics = metrics_agg(:,:, 2);

figure
hold on 
plot(thresholds, metrics(1,:))
plot(thresholds, metrics(2,:))
plot(thresholds, metrics(3,:))
plot(thresholds, metrics(4,:),'LineWidth',2)
grid on;
xlabel('Threshold Proportion');
ylabel('Metric Value');
yticks(0:0.05:1)
title('Resize before with Encoding, blocks = "avg pool"')
legend('compression ratio', 'MSE', 'SSIM', 'overall', 'Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_',file_name,'_before_enco_blocks=avg_pool_metrics.jpg'))

% plot storage ratio separately
figure
plot(thresholds, metrics(5,:))
grid on;
xlabel('Threshold Proportion')
ylabel('Storage Ratio')
title('Resize before with Encoding, blocks = "avg pool"')
legend('storage ratio')
saveas(gcf,strcat(filepath,'/graph_', file_name,'_before_enco_blocks=avg_pool_storage_ratio.jpg'))


% plot metrics for blocks = "max_pool"
metrics = metrics_agg(:,:, 3);

figure
hold on 
plot(thresholds, metrics(1,:))
plot(thresholds, metrics(2,:))
plot(thresholds, metrics(3,:))
plot(thresholds, metrics(4,:),'LineWidth',2)
grid on;
xlabel('Threshold Proportion');
ylabel('Metric Value');
yticks(0:0.05:1)
title('resize before with enco, blocks = "max pool"')
legend('compression ratio', 'MSE', 'SSIM', 'overall', 'Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_',file_name,'_before_enco_blocks=max_pool_metrics.jpg'))

% plot storage ratio separately
figure
plot(thresholds, metrics(5,:))
grid on;
xlabel('Threshold Proportion')
ylabel('Storage Ratio')
title('resize before with enco, blocks = "max pool"')
legend('storage ratio')
saveas(gcf,strcat(filepath,'/graph_', file_name,'_before_enco_blocks=max_pool_storage_ratio.jpg'))


% plot overall for all three types on the same graph
figure
hold on
metrics = metrics_agg(:,:,1);
plot(thresholds, metrics(4,:),'LineWidth',2, 'Linestyle', '-.') % blocks = "none"
metrics = metrics_agg(:,:,2); % blocks = "avg_pool"
plot(thresholds, metrics(4,:), 'LineWidth',2, 'Linestyle', ':')
metrics = metrics_agg(:,:,3); % blocks = "max_pool"
plot(thresholds, metrics(4,:), 'LineWidth',2,'Linestyle', '--')
title('Overall metric for resizing before with enco')
grid on;
xlabel('Threshold Proportion');
ylabel('Overall');
ylim([0.88 1])
legend('none', 'average pool', 'max pool', 'Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_', file_name,'_before_enco_overall_grouped.jpg'))


% plot storage ratio for all three types on the same graph
figure
hold on
metrics = metrics_agg(:,:,1);
plot(thresholds, metrics(5,:),'LineWidth',2, 'Linestyle', '-.') % blocks = "none"
metrics = metrics_agg(:,:,2); % blocks = "avg_pool"
plot(thresholds, metrics(5,:), 'LineWidth',2, 'Linestyle', ':')
metrics = metrics_agg(:,:,3); % blocks = "max_pool"
plot(thresholds, metrics(5,:), 'LineWidth',2,'Linestyle', '--')
title('Storage Ratio for resizing before with enco')
grid on;
xlabel('Threshold Proportion');
ylabel('Storage Ratio');
legend('none', 'average pool', 'max pool', 'Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_', file_name,'_before_enco_storage_ratio_grouped.jpg'))



%% Test with Huffman Encoding with Resizing After
resize = 1; % resize set to before
metrics_agg = [];
encoding = 1;
quant = 5;  

for blk = 1:length(blocks)
    file_name_blks = strcat(file_name, '_after_', blocks(blk));
    for k = 1:length(thresholds) 
        disp(thresholds(k)) % to check progress of code
        file_name_specific = strcat(file_name_blks,'_',num2str(thresholds(k)));
        final = SVD_compress(img, file_name_specific, filepath, thresholds(k), blocks(blk), resize, encoding, quant);
    end
    metrics = get_series_compressions(img, thresholds, file_name_blks, filepath, encoding);
    metrics_agg = cat(3, metrics_agg, metrics);
end

% plot metrics for blocks = "none"
metrics = metrics_agg(:,:, 1);

figure
hold on 
plot(thresholds, metrics(1,:))
plot(thresholds, metrics(2,:))
plot(thresholds, metrics(3,:))
plot(thresholds, metrics(4,:),'LineWidth',2)
grid on;
xlabel('Threshold Proportion');
ylabel('Metric Value');
yticks(0:0.05:1)
title('resize after with enco, blocks = "none"')
legend('compression ratio', 'MSE', 'SSIM', 'overall', 'Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_',file_name,'_after_enco_blocks=none_metrics.jpg'))

% plot compression ratio separately
figure
plot(thresholds, metrics(5,:))
grid on;
xlabel('Threshold Proportion')
ylabel('Storage Ratio')
title('resize after with enco, blocks = "none"')
legend('storage ratio')
saveas(gcf,strcat(filepath,'/graph_', file_name,'_after_enco_blocks=none_storage_ratio.jpg'))


% plot metrics for blocks = "none"
metrics = metrics_agg(:,:, 2);

figure
hold on 
plot(thresholds, metrics(1,:))
plot(thresholds, metrics(2,:))
plot(thresholds, metrics(3,:))
plot(thresholds, metrics(4,:),'LineWidth',2)
grid on;
xlabel('Threshold Proportion');
ylabel('Metric Value');
yticks(0:0.05:1)
title('resize after with enco, blocks = "avg pool"')
legend('compression ratio', 'MSE', 'SSIM', 'overall', 'Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_',file_name,'_after_enco_blocks=avg_pool_metrics.jpg'))

% plot compression ratio separately
figure
plot(thresholds, metrics(5,:))
grid on;
xlabel('Threshold Proportion')
ylabel('Storage Ratio')
title('resize after with enco, blocks = "avg pool"')
legend('storage ratio')
saveas(gcf,strcat(filepath,'/graph_', file_name,'_after_enco_blocks=avg_pool_storage_ratio.jpg'))


% plot metrics for blocks = "max_pool"
metrics = metrics_agg(:,:, 3);

figure
hold on 
plot(thresholds, metrics(1,:))
plot(thresholds, metrics(2,:))
plot(thresholds, metrics(3,:))
plot(thresholds, metrics(4,:),'LineWidth',2)
grid on;
xlabel('Threshold Proportion');
ylabel('Metric Value');
yticks(0:0.05:1)
title('resize after with enco, blocks = "max pool"')
legend('compression ratio', 'MSE', 'SSIM', 'overall', 'Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_',file_name,'_after_enco_blocks=max_pool_metrics.jpg'))

% plot compression ratio separately
figure
plot(thresholds, metrics(5,:))
grid on;
xlabel('Threshold Proportion')
ylabel('Storage Ratio')
title('resize after with enco, blocks = "max pool"')
legend('storage ratio')
saveas(gcf,strcat(filepath,'/graph_', file_name,'_after_enco_blocks=max_pool_storage_ratio.jpg'))

% plot overall for all three types on the same graph
figure
hold on
metrics = metrics_agg(:,:,1);
plot(thresholds, metrics(4,:),'LineWidth',2, 'Linestyle', '-.') % blocks = "none"
metrics = metrics_agg(:,:,2); % blocks = "avg_pool"
plot(thresholds, metrics(4,:), 'LineWidth',2, 'Linestyle', ':')
metrics = metrics_agg(:,:,3); % blocks = "max_pool"
plot(thresholds, metrics(4,:), 'LineWidth',2,'Linestyle', '--')
title('Overall metric for resizing after with enco')
grid on;
xlabel('Threshold Proportion');
ylabel('Overall');
ylim([0.88 1])
legend('none', 'average pool', 'max pool', 'Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_', file_name,'_after_enco_overall_grouped.jpg'))


% plot storage ratio for all three types on the same graph
figure
hold on
metrics = metrics_agg(:,:,1);
plot(thresholds, metrics(5,:),'LineWidth',2, 'Linestyle', '-.') % blocks = "none"
metrics = metrics_agg(:,:,2); % blocks = "avg_pool"
plot(thresholds, metrics(5,:), 'LineWidth',2, 'Linestyle', ':')
metrics = metrics_agg(:,:,3); % blocks = "max_pool"
plot(thresholds, metrics(5,:), 'LineWidth',2,'Linestyle', '--')
title('Storage Ratio for resizing after with enco')
grid on;
xlabel('Threshold Proportion');
ylabel('Storage Ratio');
legend('none', 'average pool', 'max pool', 'Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_', file_name,'_after_enco_storage_ratio_grouped.jpg'))


%% Test for Quantization Steps with Huff + Quant (Resize set to before)
%set parameters 
filepath = 'Results/test_huffman_quant/quant_steps';
file_name = "marina_bay";

%range of parameters tested 
quants = 5:5:40;                        %series of threshold values 
blocks = ["none", "avg_pool", "max_pool"];       %series of block types

% quantization values tested: anything above 140 gives error, anything
% above ~20-30 starts having significant loss/change in the colors

%%% Test for resizing before with Huffman
resize = 0; % resize set to before
metrics_agg = [];
encoding = 1;
thresh = 0.8;  

for blk = 1:length(blocks)
    file_name_blks = strcat(file_name, '_before_', blocks(blk));
    for q = 1:length(quants) 
        disp(quants(q)) % to check progress of code
        file_name_specific = strcat(file_name_blks,'_',num2str(quants(q)));
        final = SVD_compress(img, file_name_specific, filepath, thresh, blocks(blk), resize, encoding, quants(q));
    end
    metrics = get_series_compressions(img, quants, file_name_blks, filepath, encoding);
    metrics_agg = cat(3, metrics_agg, metrics);
end

% plot metrics for blocks = "none"
metrics = metrics_agg(:,:, 1);

figure
hold on 
plot(quants, metrics(1,:))
plot(quants, metrics(2,:))
plot(quants, metrics(3,:))
plot(quants, metrics(4,:),'LineWidth',2)
grid on;
xlabel('Quantization Step');
ylabel('Metric Value');
yticks(0:0.05:1)
title('resize before with enco, blocks = "none"')
legend('compression ratio', 'MSE', 'SSIM', 'overall', 'Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_',file_name,'_before_enco_blocks=none_metrics.jpg'))

% plot compression ratio separately
figure
plot(quants, metrics(5,:))
grid on;
xlabel('Quantization Step')
ylabel('Storage Ratio')
title('resize before with enco, blocks = "none"')
legend('storage ratio')
saveas(gcf,strcat(filepath,'/graph_', file_name,'_before_enco_blocks=none_storage_ratio.jpg'))


% plot metrics for blocks = "none"
metrics = metrics_agg(:,:, 2);

figure
hold on 
plot(quants, metrics(1,:))
plot(quants, metrics(2,:))
plot(quants, metrics(3,:))
plot(quants, metrics(4,:),'LineWidth',2)
grid on;
xlabel('Quantization Step');
ylabel('Metric Value');
yticks(0:0.05:1)
title('resize before with enco, blocks = "avg pool"')
legend('compression ratio', 'MSE', 'SSIM', 'overall', 'Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_',file_name,'_before_enco_blocks=avg_pool_metrics.jpg'))

% plot compression ratio separately
figure
plot(quants, metrics(5,:))
grid on;
xlabel('Quantization Step')
ylabel('Storage Ratio')
title('resize before with enco, blocks = "avg pool"')
legend('storage ratio')
saveas(gcf,strcat(filepath,'/graph_', file_name,'_before_enco_blocks=avg_pool_storage_ratio.jpg'))

% plot metrics for blocks = "max_pool"
metrics = metrics_agg(:,:, 3);

figure
hold on 
plot(quants, metrics(1,:))
plot(quants, metrics(2,:))
plot(quants, metrics(3,:))
plot(quants, metrics(4,:),'LineWidth',2)
grid on;
xlabel('Quantization Step');
ylabel('Metric Value');
yticks(0:0.05:1)
title('resize before with enco, blocks = "max pool"')
legend('compression ratio', 'MSE', 'SSIM', 'overall', 'Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_',file_name,'_before_enco_blocks=max_pool_metrics.jpg'))

% plot compression ratio separately
figure
plot(quants, metrics(5,:))
grid on;
xlabel('Quantization Step')
ylabel('Storage Ratio')
title('resize before with enco, blocks = "max pool"')
legend('storage ratio')
saveas(gcf,strcat(filepath,'/graph_', file_name,'_before_enco_blocks=max_pool_storage_ratio.jpg'))

% plot overall for all three types on the same graph
figure
hold on
metrics = metrics_agg(:,:,1);
plot(quants, metrics(4,:),'LineWidth',2, 'Linestyle', '-.') % blocks = "none"
metrics = metrics_agg(:,:,2); % blocks = "avg_pool"
plot(quants, metrics(4,:), 'LineWidth',2, 'Linestyle', ':')
metrics = metrics_agg(:,:,3); % blocks = "max_pool"
plot(quants, metrics(4,:), 'LineWidth',2,'Linestyle', '--')
title('Overall metric for resizing before with enco')
grid on;
xlabel('Quantization Step');
ylabel('Overall');
ylim([0.88 1])
legend('none', 'average pool', 'max pool', 'Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_', file_name,'_before_enco_overall_grouped.jpg'))


% plot storage ratio for all three types on the same graph
figure
hold on
metrics = metrics_agg(:,:,1);
plot(quants, metrics(5,:),'LineWidth',2, 'Linestyle', '-.') % blocks = "none"
metrics = metrics_agg(:,:,2); % blocks = "avg_pool"
plot(quants, metrics(5,:), 'LineWidth',2, 'Linestyle', ':')
metrics = metrics_agg(:,:,3); % blocks = "max_pool"
plot(quants, metrics(5,:), 'LineWidth',2,'Linestyle', '--')
title('Storage Ratio for resizing before with enco')
grid on;
xlabel('Quantization Step');
ylabel('Storage Ratio');
legend('none', 'average pool', 'max pool', 'Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_', file_name,'_before_enco_storage_ratio_grouped.jpg'))

%% Test for resizing after with Huffman
resize = 1; % resize set to before
metrics_agg = [];
encoding = 1;
thresh = 0.8;

for blk = 1:length(blocks)
    file_name_blks = strcat(file_name, '_after_', blocks(blk));
    for q = 1:length(quants)
        disp(quants(q)) % to check progress of code
        file_name_specific = strcat(file_name_blks,'_',num2str(quants(q)));
        final = SVD_compress(img, file_name_specific, filepath, thresh, blocks(blk), resize, encoding, quants(q));
    end
    metrics = get_series_compressions(img, quants, file_name_blks, filepath, encoding);
    metrics_agg = cat(3, metrics_agg, metrics);
end

% plot metrics for blocks = "none"
metrics = metrics_agg(:,:, 1);

figure
hold on 
plot(quants, metrics(1,:))
plot(quants, metrics(2,:))
plot(quants, metrics(3,:))
plot(quants, metrics(4,:),'LineWidth',2)
grid on;
xlabel('Quantization Step');
ylabel('Metric Value');
yticks(0:0.05:1)
title('resize after with enco, blocks = "none"')
legend('compression ratio', 'MSE', 'SSIM', 'overall', 'Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_',file_name,'_after_enco_blocks=none_metrics.jpg'))

% plot compression ratio separately
figure
plot(quants, metrics(5,:))
grid on;
xlabel('Quantization Step')
ylabel('Storage Ratio')
title('resize after with enco, blocks = "none"')
legend('storage ratio')
saveas(gcf,strcat(filepath,'/graph_', file_name,'_after_enco_blocks=none_storage_ratio.jpg'))


% plot metrics for blocks = "none"
metrics = metrics_agg(:,:, 2);

figure
hold on 
plot(quants, metrics(1,:))
plot(quants, metrics(2,:))
plot(quants, metrics(3,:))
plot(quants, metrics(4,:),'LineWidth',2)
grid on;
xlabel('Quantization Step');
ylabel('Metric Value');
yticks(0:0.05:1)
title('resize after with enco, blocks = "avg pool"')
legend('compression ratio', 'MSE', 'SSIM', 'overall', 'Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_',file_name,'_after_enco_blocks=avg_pool_metrics.jpg'))

% plot compression ratio separately
figure
plot(quants, metrics(5,:))
grid on;
xlabel('Quantization Step')
ylabel('Storage Ratio')
title('resize after with enco, blocks = "avg pool"')
legend('storage ratio')
saveas(gcf,strcat(filepath,'/graph_', file_name,'_after_enco_blocks=avg_pool_storage_ratio.jpg'))


% plot metrics for blocks = "max_pool"
metrics = metrics_agg(:,:, 3);

figure
hold on 
plot(quants, metrics(1,:))
plot(quants, metrics(2,:))
plot(quants, metrics(3,:))
plot(quants, metrics(4,:),'LineWidth',2)
grid on;
xlabel('Quantization Step');
ylabel('Metric Value');
yticks(0:0.05:1)
title('resize after with enco, blocks = "max pool"')
legend('compression ratio', 'MSE', 'SSIM', 'overall', 'Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_',file_name,'_after_enco_blocks=max_pool_metrics.jpg'))

% plot compression ratio separately
figure
plot(quants, metrics(5,:))
grid on;
xlabel('Quantization Step')
ylabel('Storage Ratio')
title('resize after with enco, blocks = "max pool"')
legend('storage ratio')
saveas(gcf,strcat(filepath,'/graph_', file_name,'_after_enco_blocks=max_pool_storage_ratio.jpg'))

% plot overall for all three types on the same graph
figure
hold on
metrics = metrics_agg(:,:,1);
plot(quants, metrics(4,:),'LineWidth',2, 'Linestyle', '-.') % blocks = "none"
metrics = metrics_agg(:,:,2); % blocks = "avg_pool"
plot(quants, metrics(4,:), 'LineWidth',2, 'Linestyle', ':')
metrics = metrics_agg(:,:,3); % blocks = "max_pool"
plot(quants, metrics(4,:), 'LineWidth',2,'Linestyle', '--')
title('Overall metric for resizing after with enco')
grid on;
xlabel('Quantization Step');
ylabel('Overall');
ylim([0.88 1])
legend('none', 'average pool', 'max pool', 'Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_', file_name,'_after_enco_overall_grouped.jpg'))


% plot storage ratio for all three types on the same graph
figure
hold on
metrics = metrics_agg(:,:,1);
plot(quants, metrics(5,:),'LineWidth',2, 'Linestyle', '-.') % blocks = "none"
metrics = metrics_agg(:,:,2); % blocks = "avg_pool"
plot(quants, metrics(5,:), 'LineWidth',2, 'Linestyle', ':')
metrics = metrics_agg(:,:,3); % blocks = "max_pool"
plot(quants, metrics(5,:), 'LineWidth',2,'Linestyle', '--')
title('Storage Ratio for resizing after with enco')
grid on;
xlabel('Quantization Step');
ylabel('Storage Ratio');
legend('none', 'average pool', 'max pool', 'Location', 'northeastout', 'FontSize', 8)
hold off
saveas(gcf,strcat(filepath,'/graph_', file_name,'_after_enco_storage_ratio_grouped.jpg'))