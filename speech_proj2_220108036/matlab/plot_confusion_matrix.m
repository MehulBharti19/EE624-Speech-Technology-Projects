function plot_confusion_matrix(C, classLabels, plotTitle)

figure('Color','w');
imagesc(C);
axis image;
colormap(parula);
colorbar;

set(gca, 'XTick', 1:numel(classLabels), 'XTickLabel', string(classLabels));
set(gca, 'YTick', 1:numel(classLabels), 'YTickLabel', string(classLabels));

xlabel('Predicted digit');
ylabel('True digit');
title(plotTitle);

for i = 1:size(C,1)
    for j = 1:size(C,2)
        text(j, i, num2str(C(i,j)), ...
            'HorizontalAlignment', 'center', ...
            'Color', 'w', ...
            'FontWeight', 'bold');
    end
end

end