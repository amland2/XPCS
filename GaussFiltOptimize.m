mkdir('GaussFiltOptimize')
for i = 1:20
    img=imgaussfilt(C,i);
    imagesc(img); axis xy; axis image; colorbar;
    saveas(gcf, strcat(pwd,'\GaussFiltOptimize\',sprintf('%d.tif',i)));
end