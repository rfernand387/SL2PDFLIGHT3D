load('E:\sl2p_v3\Report_s2_sl2p_calmitcorn_mc_prosail\Class_1\s2_sl2p_calmitcorn_mc_prosail.mat')
data = Perf_Actual.NNT3.s2_sl2p_calmitcorn_mc_prosail;
N = length(data.LAI.Valid);
low = find(data.LAI.Valid<3);
Nlow = length(low);
high = find(data.LAI.Valid>=3);
Nhigh = length(high);
Var_Name=fieldnames(data);
Var_Name = Var_Name(~ismember(Var_Name,[{'Input'}]));
for ovar = 1:length(Var_Name)
    data.(Var_Name{ovar}).rmseall = rmse(data.(Var_Name{ovar}).Estime,data.(Var_Name{ovar}).Valid);
    [data.(Var_Name{ovar}).slopeall data.(Var_Name{ovar}).offsetall] = polyfit(data.(Var_Name{ovar}).Estime,data.(Var_Name{ovar}).Valid,1);
    if ( strcmp(Var_Name,'LAI') )
    data.(Var_Name{ovar}).uar = sum([abs((data.(Var_Name{ovar}).Valid(data.(Var_Name{ovar}).Valid<1)-data.(Var_Name{ovar}).Estime(data.(Var_Name{ovar}).Valid<1))<1) abs((data.(Var_Name{ovar}).Valid(data.(Var_Name{ovar}).Valid>1)-data.(Var_Name{ovar}).Estime(data.(Var_Name{ovar}).Valid>1))./data.(Var_Name{ovar}).Valid(data.(Var_Name{ovar}).Valid>1)<0.2)])/N;
    elseif  ( strcmp(Var_Name,'CWC') )
    data.(Var_Name{ovar}).uar = sum([abs((data.(Var_Name{ovar}).Valid(data.(Var_Name{ovar}).Valid<1)-data.(Var_Name{ovar}).Estime(data.(Var_Name{ovar}).Valid<1))<1) abs((data.(Var_Name{ovar}).Valid(data.(Var_Name{ovar}).Valid>1)-data.(Var_Name{ovar}).Estime(data.(Var_Name{ovar}).Valid>1))./data.(Var_Name{ovar}).Valid(data.(Var_Name{ovar}).Valid>1)<0.2)])/N;
    else
    data.(Var_Name{ovar}).uar = sum([abs((data.(Var_Name{ovar}).Valid(data.(Var_Name{ovar}).Valid<1)-data.(Var_Name{ovar}).Estime(data.(Var_Name{ovar}).Valid<1))<1) abs((data.(Var_Name{ovar}).Valid(data.(Var_Name{ovar}).Valid>1)-data.(Var_Name{ovar}).Estime(data.(Var_Name{ovar}).Valid>1))./data.(Var_Name{ovar}).Valid(data.(Var_Name{ovar}).Valid>1)<0.2)])/N;

    data.(Var_Name{ovar}).rmselow = rmse(data.(Var_Name{ovar}).Valid(low),data.(Var_Name{ovar}).Estime(low));
    data.(Var_Name{ovar}).rmsehigh = rmse(data.(Var_Name{ovar}).Valid(high),data.(Var_Name{ovar}).Estime(high));

end
