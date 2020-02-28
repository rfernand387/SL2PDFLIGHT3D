
    
    %%  
  f1 = figure

  clf
  s1=subplot(2,1,1)
  y = [];
  dhat = [];
  cgroup = [];
  for d = 1:(length(Dlist)-1)
      
%       index = find((Perf_Actual.NNT7.s2_sl2p_uniform_sobol_prosailD.D.Estime>=Dlist(d)).*((Perf_Actual.NNT7.s2_sl2p_uniform_sobol_prosailD.D.Estime<Dlist(d+1))));
%       y = [y ;  Perf_Actual.NNT7.s2_sl2p_uniform_sobol_prosailD.FCOVER.Valid(index) ];
%      dhat = [dhat ; round(repmat((Dlist(d)+Dlist(d+1))/2,length(index),1),1)];
%        cgroup = [cgroup ; 1+0*index];
%       index = find((Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosail.D.Estime>=Dlist(d)).*((Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosail.D.Estime<Dlist(d+1))));
%       y = [y ; Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosail.FCOVER.Valid(index) ];
%      dhat = [dhat ; round(repmat((Dlist(d)+Dlist(d+1))/2,length(index),1),1)+0.025];
%        cgroup = [cgroup ; 2+0*index];
      index = find((Perf_Actual.NNT7.s2_sl2p_calmitcorn_mc_prosail.D.Estime>=Dlist(d)).*((Perf_Actual.NNT7.s2_sl2p_calmitcorn_mc_prosail.D.Estime<Dlist(d+1))));
      y = [y ; Perf_Actual.NNT7.s2_sl2p_calmitcorn_mc_prosail.FCOVER.Valid(index) ];
     dhat = [dhat ; round(repmat((Dlist(d)+Dlist(d+1))/2,length(index),1),1)+0.05];
       cgroup = [cgroup ; 3+0*index];

  end
%        index = find((Perf_Actual.NNT7.s2_sl2p_uniform_sobol_prosailD.D.Estime>=Dlist(d)).*((Perf_Actual.NNT7.s2_sl2p_uniform_sobol_prosailD.D.Estime<Dlist(d+1))));
%       y = [y ;  Output.FCOVER(index) ];
%      dhat = [dhat ; round(repmat((Dlist(d)+Dlist(d+1))/2,length(index),1),1)];
%        cgroup = [cgroup ; 1+0*index];
%   index = find((Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosail.D.Estime>=Dlist(d+1)).*((Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosail.D.Estime<1)));
%       y = [y ; Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosail.FCOVER.Valid(index) ];
%      dhat = [dhat ; round(repmat((Dlist(d)+Dlist(d+1))/2,length(index),1),1)+0.25];
%             cgroup = [cgroup ; 2+0*index];
                  index = find((Perf_Actual.NNT7.s2_sl2p_calmitcorn_mc_prosail.D.Estime>=Dlist(d+1)).*((Perf_Actual.NNT7.s2_sl2p_calmitcorn_mc_prosail.D.Estime<1)));
      y = [y ; Perf_Actual.NNT7.s2_sl2p_calmitcorn_mc_prosail.FCOVER.Valid(index) ];
     dhat = [dhat ; round(repmat((Dlist(d)+Dlist(d+1))/2,length(index),1),1)+0.05];
            cgroup = [cgroup ; 3+0*index];
     boxplot(y,round(dhat,2),'ColorGroup',cgroup,'Symbol','')
            hold on
 
xticklabels({'','0.0','','','0.1','','','0.2','','','0.3','','','0.4','','','0.5','','','0.6','','','0.7','','','0.8','','','0.9',''})
                xlabel('$$\hat{D}$$' ,'Interpreter','Latex' );
    ylabel('FCOVER');
                yy = (grpstats(y,dhat,@median));
        stdyy = median(grpstats(y,dhat,@var));
    scatterratio = 1-round(stdyy ./var(y),2);
    text(1,max(y),['R^2=',num2str(scatterratio)])
    
    s2=subplot(2,1,2)
    y = [];
  dhat = [];
  cgroup = [];
  for d = 1:(length(Dlist)-1)
      
%       index = find((Perf_Actual.NNT7.s2_sl2p_uniform_sobol_prosailD.D.Estime>=Dlist(d)).*((Perf_Actual.NNT7.s2_sl2p_uniform_sobol_prosailD.D.Estime<Dlist(d+1))));
%       y = [y ; Perf_Actual.NNT7.s2_sl2p_uniform_sobol_prosailD.LAI.Valid(index) ];
%      dhat = [dhat ; round(repmat((Dlist(d)+Dlist(d+1))/2,length(index),1),1)];
%        cgroup = [cgroup ; 1+0*index];
%       index = find((Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosail.D.Estime>=Dlist(d)).*((Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosail.D.Estime<Dlist(d+1))));
%       y = [y ; Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosail.LAI.Valid(index) ];
%      dhat = [dhat ; round(repmat((Dlist(d)+Dlist(d+1))/2,length(index),1),1)+0.025];
%        cgroup = [cgroup ; 2+0*index];
      index = find((Perf_Actual.NNT7.s2_sl2p_calmitcorn_mc_prosail.D.Estime>=Dlist(d)).*((Perf_Actual.NNT7.s2_sl2p_calmitcorn_mc_prosail.D.Estime<Dlist(d+1))));
      y = [y ; Perf_Actual.NNT7.s2_sl2p_calmitcorn_mc_prosail.LAI.Valid(index) ];
     dhat = [dhat ; round(repmat((Dlist(d)+Dlist(d+1))/2,length(index),1),1)+0.05];
       cgroup = [cgroup ; 3+0*index];

  end
%        index = find((Perf_Actual.NNT7.s2_sl2p_uniform_sobol_prosailD.D.Estime>=Dlist(d)).*((Perf_Actual.NNT7.s2_sl2p_uniform_sobol_prosailD.D.Estime<Dlist(d+1))));
%       y = [y ; Perf_Actual.NNT7.s2_sl2p_uniform_sobol_prosailD.LAI.Valid(index) ];
%      dhat = [dhat ; round(repmat((Dlist(d)+Dlist(d+1))/2,length(index),1),1)];
%        cgroup = [cgroup ; 1+0*index];
%   index = find((Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosail.D.Estime>=Dlist(d+1)).*((Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosail.D.Estime<1)));
%       y = [y ; Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosail.LAI.Valid(index) ];
%      dhat = [dhat ; round(repmat((Dlist(d)+Dlist(d+1))/2,length(index),1),1)+0.25];
%             cgroup = [cgroup ; 2+0*index];
                  index = find((Perf_Actual.NNT7.s2_sl2p_calmitcorn_mc_prosail.D.Estime>=Dlist(d+1)).*((Perf_Actual.NNT7.s2_sl2p_calmitcorn_mc_prosail.D.Estime<1)));
      y = [y ; Perf_Actual.NNT7.s2_sl2p_calmitcorn_mc_prosail.LAI.Valid(index) ];
     dhat = [dhat ; round(repmat((Dlist(d)+Dlist(d+1))/2,length(index),1),1)+0.05];
            cgroup = [cgroup ; 3+0*index];
     boxplot(y,round(dhat,2),'ColorGroup',cgroup,'Symbol','')
            hold on
 
xticklabels({'','0.0','','','0.1','','','0.2','','','0.3','','','0.4','','','0.5','','','0.6','','','0.7','','','0.8','','','0.9',''})
                xlabel('$$\hat{D}$$' ,'Interpreter','Latex' );
    ylabel('LAI');
                    yy = (grpstats(y,dhat,@median));
        stdyy = median(grpstats(y,dhat,@var));
    scatterratio = 1-round(stdyy ./var(y),2);
    text(1,max(y),['R^2=',num2str(scatterratio)])
    