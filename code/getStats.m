function getStats(data,thresh,thresh2)
display('Fcover low')
rmsd=sqrt(mse(data.FCOVER.Estime(data.LAI.Valid<thresh),data.FCOVER.Valid(data.LAI.Valid<thresh)));
bias=mean(data.FCOVER.Estime(data.LAI.Valid<thresh)-data.FCOVER.Valid(data.LAI.Valid<thresh));
lm = fitlm(data.FCOVER.Estime(data.LAI.Valid<thresh),data.FCOVER.Valid(data.LAI.Valid<thresh));
slope=lm.Coefficients{2,1};
uar=sum( abs((data.FCOVER.Estime(data.LAI.Valid<thresh)-data.FCOVER.Valid(data.LAI.Valid<thresh)))< max( 0.15,0.1*data.FCOVER.Valid(data.LAI.Valid<thresh)))/length(data.FCOVER.Valid(data.LAI.Valid<thresh));
[rmsd , bias, slope, uar]

display('Fcover high')
rmsd=sqrt(mse(data.FCOVER.Estime(data.LAI.Valid>thresh2),data.FCOVER.Valid(data.LAI.Valid>thresh2)));
bias=mean(data.FCOVER.Estime(data.LAI.Valid>thresh2)-data.FCOVER.Valid(data.LAI.Valid>thresh2));
lm = fitlm(data.FCOVER.Estime(data.LAI.Valid>thresh2),data.FCOVER.Valid(data.LAI.Valid>thresh2));
slope=lm.Coefficients{2,1};
uar=sum( abs((data.FCOVER.Estime(data.LAI.Valid>thresh2)-data.FCOVER.Valid(data.LAI.Valid>thresh2)))< max( 0.15,0.1*data.FCOVER.Valid(data.LAI.Valid>thresh2)))/length(data.FCOVER.Valid(data.LAI.Valid>thresh2));
[rmsd , bias, slope, uar]

display('LAI low')
rmsd=sqrt(mse(data.LAI.Estime(data.LAI.Valid<thresh),data.LAI.Valid(data.LAI.Valid<thresh)));
bias=mean(data.LAI.Estime(data.LAI.Valid<thresh)-data.LAI.Valid(data.LAI.Valid<thresh));
lm = fitlm(data.LAI.Estime(data.LAI.Valid<thresh),data.LAI.Valid(data.LAI.Valid<thresh));
slope=lm.Coefficients{2,1};
uar=sum( abs((data.LAI.Estime(data.LAI.Valid<thresh)-data.LAI.Valid(data.LAI.Valid<thresh)))< max( 1,0.2*data.LAI.Valid(data.LAI.Valid<thresh)))/length(data.LAI.Valid(data.LAI.Valid<thresh));
[rmsd , bias, slope, uar]

display('LAI high')
rmsd=sqrt(mse(data.LAI.Estime(data.LAI.Valid>thresh2),data.LAI.Valid(data.LAI.Valid>thresh2)));
bias=mean(data.LAI.Estime(data.LAI.Valid>thresh2)-data.LAI.Valid(data.LAI.Valid>thresh2));
lm = fitlm(data.LAI.Estime(data.LAI.Valid>thresh2),data.LAI.Valid(data.LAI.Valid>thresh2));
slope=lm.Coefficients{2,1};
uar=sum( abs((data.LAI.Estime(data.LAI.Valid>thresh2)-data.LAI.Valid(data.LAI.Valid>thresh2)))< max( 1,0.2*data.LAI.Valid(data.LAI.Valid>thresh2)))/length(data.LAI.Valid(data.LAI.Valid>thresh2));
[rmsd , bias, slope, uar]

display('CWC low')
rmsd=sqrt(mse(data.LAI_Cw.Estime(data.LAI.Valid<thresh),data.LAI_Cw.Valid(data.LAI.Valid<thresh)));
bias=mean(data.LAI_Cw.Estime(data.LAI.Valid<thresh)-data.LAI_Cw.Valid(data.LAI.Valid<thresh));
lm = fitlm(data.LAI_Cw.Estime(data.LAI.Valid<thresh),data.LAI_Cw.Valid(data.LAI.Valid<thresh));
slope=lm.Coefficients{2,1};
uar=sum( abs((data.LAI_Cw.Estime(data.LAI.Valid<thresh)-data.LAI_Cw.Valid(data.LAI.Valid<thresh)))< max( 0,0.2*data.LAI_Cw.Valid(data.LAI.Valid<thresh)))/length(data.LAI_Cw.Valid(data.LAI.Valid<thresh));
[rmsd , bias, slope, uar]

display('CWC high')
rmsd=sqrt(mse(data.LAI_Cw.Estime(data.LAI.Valid>thresh2),data.LAI_Cw.Valid(data.LAI.Valid>thresh2)));
bias=mean(data.LAI_Cw.Estime(data.LAI.Valid>thresh2)-data.LAI_Cw.Valid(data.LAI.Valid>thresh2));
lm = fitlm(data.LAI_Cw.Estime(data.LAI.Valid>thresh2),data.LAI_Cw.Valid(data.LAI.Valid>thresh2));
slope=lm.Coefficients{2,1};
uar=sum( abs((data.LAI_Cw.Estime(data.LAI.Valid>thresh2)-data.LAI_Cw.Valid(data.LAI.Valid>thresh2)))< max( 0,0.2*data.LAI_Cw.Valid(data.LAI.Valid>thresh2)))/length(data.LAI_Cw.Valid(data.LAI.Valid>thresh2));
[rmsd , bias, slope, uar]
return

