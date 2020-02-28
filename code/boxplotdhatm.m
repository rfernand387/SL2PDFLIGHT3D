
    
    %%  
  f1 = figure

  clf
  s1=subplot(2,2,1)
  y = [];
  dhat = [];
  cgroup = [];
  for d = 1:(length(Dlist)-1)
      
      index = find((Perf_Actual.NNT7.s2_sl2p_uniform_sobol_prosailD.D.Estime>=Dlist(d)).*((Perf_Actual.NNT7.s2_sl2p_uniform_sobol_prosailD.D.Estime<Dlist(d+1))));
      y = [y ;  Perf_Actual.NNT7.s2_sl2p_uniform_sobol_prosailD.FCOVER.Valid(index) ];
     dhat = [dhat ; round(repmat((Dlist(d)+Dlist(d+1))/2,length(index),1),1)];
       cgroup = [cgroup ; 1+0*index];
%       index = find((Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosailuniformLAI.D.Estime>=Dlist(d)).*((Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosailuniformLAI.D.Estime<Dlist(d+1))));
%       y = [y ; Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosailuniformLAI.FCOVER.Valid(index) ];
%      dhat = [dhat ; round(repmat((Dlist(d)+Dlist(d+1))/2,length(index),1),1)+0.025];
%        cgroup = [cgroup ; 2+0*index];
%       index = find((Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosail.D.Estime>=Dlist(d)).*((Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosail.D.Estime<Dlist(d+1))));
%       y = [y ; Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosail.FCOVER.Valid(index) ];
%      dhat = [dhat ; round(repmat((Dlist(d)+Dlist(d+1))/2,length(index),1),1)+0.05];
%        cgroup = [cgroup ; 3+0*index];

  end
       index = find((Perf_Actual.NNT7.s2_sl2p_uniform_sobol_prosailD.D.Estime>=Dlist(d)).*((Perf_Actual.NNT7.s2_sl2p_uniform_sobol_prosailD.D.Estime<Dlist(d+1))));
      y = [y ;  Perf_Actual.NNT7.s2_sl2p_uniform_sobol_prosailD.FCOVER.Valid(index) ];
     dhat = [dhat ; round(repmat((Dlist(d)+Dlist(d+1))/2,length(index),1),1)];
       cgroup = [cgroup ; 1+0*index];
%   index = find((Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosailuniformLAI.D.Estime>=Dlist(d+1)).*((Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosailuniformLAI.D.Estime<1)));
%       y = [y ; Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosailuniformLAI.FCOVER.Valid(index) ];
%      dhat = [dhat ; round(repmat((Dlist(d)+Dlist(d+1))/2,length(index),1),1)+0.25];
%             cgroup = [cgroup ; 2+0*index];
%                   index = find((Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosail.D.Estime>=Dlist(d+1)).*((Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosail.D.Estime<1)));
%       y = [y ; Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosail.FCOVER.Valid(index) ];
%      dhat = [dhat ; round(repmat((Dlist(d)+Dlist(d+1))/2,length(index),1),1)+0.05];
%             cgroup = [cgroup ; 3+0*index];
     boxplot(y,round(dhat,2),'ColorGroup',cgroup,'Symbol','')
            hold on
 
xticklabels({'','0.0','','','0.1','','','0.2','','','0.3','','','0.4','','','0.5','','','0.6','','','0.7','','','0.8','','','0.9',''})
                xlabel('$$\hat{D}$$' ,'Interpreter','Latex' );
    ylabel('FCOVER');
    
    s2=subplot(2,2,4)
    y = [];
  dhat = [];
  cgroup = [];
  for d = 1:(length(Dlist)-1)
      
      index = find((Perf_Actual.NNT7.s2_sl2p_uniform_sobol_prosailD.D.Estime>=Dlist(d)).*((Perf_Actual.NNT7.s2_sl2p_uniform_sobol_prosailD.D.Estime<Dlist(d+1))));
      y = [y ; Perf_Actual.NNT7.s2_sl2p_uniform_sobol_prosailD.LAI_Cab.Valid(index)./Perf_Actual.NNT7.s2_sl2p_uniform_sobol_prosailD.LAI.Valid(index) ];
     dhat = [dhat ; round(repmat((Dlist(d)+Dlist(d+1))/2,length(index),1),1)];
       cgroup = [cgroup ; 1+0*index];
%       index = find((Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosailuniformLAI.D.Estime>=Dlist(d)).*((Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosailuniformLAI.D.Estime<Dlist(d+1))));
%       y = [y ; Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosailuniformLAI.LAI.Valid(index) ];
%      dhat = [dhat ; round(repmat((Dlist(d)+Dlist(d+1))/2,length(index),1),1)+0.025];
%        cgroup = [cgroup ; 2+0*index];
%       index = find((Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosail.D.Estime>=Dlist(d)).*((Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosail.D.Estime<Dlist(d+1))));
%       y = [y ; Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosail.LAI.Valid(index) ];
%      dhat = [dhat ; round(repmat((Dlist(d)+Dlist(d+1))/2,length(index),1),1)+0.05];
%        cgroup = [cgroup ; 3+0*index];

  end
       index = find((Perf_Actual.NNT7.s2_sl2p_uniform_sobol_prosailD.D.Estime>=Dlist(d)).*((Perf_Actual.NNT7.s2_sl2p_uniform_sobol_prosailD.D.Estime<Dlist(d+1))));
      y = [y ; Perf_Actual.NNT7.s2_sl2p_uniform_sobol_prosailD.LAI_Cab.Valid(index)./Perf_Actual.NNT7.s2_sl2p_uniform_sobol_prosailD.LAI.Valid(index) ];
     dhat = [dhat ; round(repmat((Dlist(d)+Dlist(d+1))/2,length(index),1),1)];
       cgroup = [cgroup ; 1+0*index];
%   index = find((Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosailuniformLAI.D.Estime>=Dlist(d+1)).*((Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosailuniformLAI.D.Estime<1)));
%       y = [y ; Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosailuniformLAI.LAI.Valid(index) ];
%      dhat = [dhat ; round(repmat((Dlist(d)+Dlist(d+1))/2,length(index),1),1)+0.25];
%             cgroup = [cgroup ; 2+0*index];
%                   index = find((Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosail.D.Estime>=Dlist(d+1)).*((Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosail.D.Estime<1)));
%       y = [y ; Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosail.LAI.Valid(index) ];
%      dhat = [dhat ; round(repmat((Dlist(d)+Dlist(d+1))/2,length(index),1),1)+0.05];
%             cgroup = [cgroup ; 3+0*index];
     boxplot(y,round(dhat,2),'ColorGroup',cgroup,'Symbol','')
            hold on
 
xticklabels({'','0.0','','','0.1','','','0.2','','','0.3','','','0.4','','','0.5','','','0.6','','','0.7','','','0.8','','','0.9',''})
                xlabel('$$\hat{D}$$' ,'Interpreter','Latex' );
    ylabel('LAI');
    
        s2=subplot(2,2,2)
    y = [];
  dhat = [];
  cgroup = [];
  for d = 1:(length(Dlist)-1)
      
      index = find((Perf_Actual.NNT7.s2_sl2p_uniform_sobol_prosailD.D.Estime>=Dlist(d)).*((Perf_Actual.NNT7.s2_sl2p_uniform_sobol_prosailD.D.Estime<Dlist(d+1))));
      y = [y ; Perf_Actual.NNT7.s2_sl2p_uniform_sobol_prosailD.LAI_Cw.Valid(index)./Perf_Actual.NNT7.s2_sl2p_uniform_sobol_prosailD.LAI.Valid(index) ];
     dhat = [dhat ; round(repmat((Dlist(d)+Dlist(d+1))/2,length(index),1),1)];
       cgroup = [cgroup ; 1+0*index];
%       index = find((Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosailuniformLAI.D.Estime>=Dlist(d)).*((Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosailuniformLAI.D.Estime<Dlist(d+1))));
%       y = [y ; Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosailuniformLAI.LAI.Valid(index) ];
%      dhat = [dhat ; round(repmat((Dlist(d)+Dlist(d+1))/2,length(index),1),1)+0.025];
%        cgroup = [cgroup ; 2+0*index];
%       index = find((Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosail.D.Estime>=Dlist(d)).*((Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosail.D.Estime<Dlist(d+1))));
%       y = [y ; Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosail.LAI.Valid(index) ];
%      dhat = [dhat ; round(repmat((Dlist(d)+Dlist(d+1))/2,length(index),1),1)+0.05];
%        cgroup = [cgroup ; 3+0*index];

  end
       index = find((Perf_Actual.NNT7.s2_sl2p_uniform_sobol_prosailD.D.Estime>=Dlist(d)).*((Perf_Actual.NNT7.s2_sl2p_uniform_sobol_prosailD.D.Estime<Dlist(d+1))));
      y = [y ; Perf_Actual.NNT7.s2_sl2p_uniform_sobol_prosailD.LAI_Cw.Valid(index)./Perf_Actual.NNT7.s2_sl2p_uniform_sobol_prosailD.LAI.Valid(index) ];
     dhat = [dhat ; round(repmat((Dlist(d)+Dlist(d+1))/2,length(index),1),1)];
       cgroup = [cgroup ; 1+0*index];
%   index = find((Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosailuniformLAI.D.Estime>=Dlist(d+1)).*((Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosailuniformLAI.D.Estime<1)));
%       y = [y ; Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosailuniformLAI.LAI.Valid(index) ];
%      dhat = [dhat ; round(repmat((Dlist(d)+Dlist(d+1))/2,length(index),1),1)+0.25];
%             cgroup = [cgroup ; 2+0*index];
%                   index = find((Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosail.D.Estime>=Dlist(d+1)).*((Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosail.D.Estime<1)));
%       y = [y ; Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosail.LAI.Valid(index) ];
%      dhat = [dhat ; round(repmat((Dlist(d)+Dlist(d+1))/2,length(index),1),1)+0.05];
%             cgroup = [cgroup ; 3+0*index];
     boxplot(y,round(dhat,2),'ColorGroup',cgroup,'Symbol','')
            hold on
 
xticklabels({'','0.0','','','0.1','','','0.2','','','0.3','','','0.4','','','0.5','','','0.6','','','0.7','','','0.8','','','0.9',''})
                xlabel('$$\hat{D}$$' ,'Interpreter','Latex' );
    ylabel('Cab');
    
        s2=subplot(2,2,3)
    y = [];
  dhat = [];
  cgroup = [];
  for d = 1:(length(Dlist)-1)
      
      index = find((Perf_Actual.NNT7.s2_sl2p_uniform_sobol_prosailD.D.Estime>=Dlist(d)).*((Perf_Actual.NNT7.s2_sl2p_uniform_sobol_prosailD.D.Estime<Dlist(d+1))));
      y = [y ; Perf_Actual.NNT7.s2_sl2p_uniform_sobol_prosailD.LAI.Valid(index) ];
     dhat = [dhat ; round(repmat((Dlist(d)+Dlist(d+1))/2,length(index),1),1)];
       cgroup = [cgroup ; 1+0*index];
%       index = find((Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosailuniformLAI.D.Estime>=Dlist(d)).*((Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosailuniformLAI.D.Estime<Dlist(d+1))));
%       y = [y ; Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosailuniformLAI.LAI.Valid(index) ];
%      dhat = [dhat ; round(repmat((Dlist(d)+Dlist(d+1))/2,length(index),1),1)+0.025];
%        cgroup = [cgroup ; 2+0*index];
%       index = find((Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosail.D.Estime>=Dlist(d)).*((Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosail.D.Estime<Dlist(d+1))));
%       y = [y ; Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosail.LAI.Valid(index) ];
%      dhat = [dhat ; round(repmat((Dlist(d)+Dlist(d+1))/2,length(index),1),1)+0.05];
%        cgroup = [cgroup ; 3+0*index];

  end
       index = find((Perf_Actual.NNT7.s2_sl2p_uniform_sobol_prosailD.D.Estime>=Dlist(d)).*((Perf_Actual.NNT7.s2_sl2p_uniform_sobol_prosailD.D.Estime<Dlist(d+1))));
      y = [y ; Perf_Actual.NNT7.s2_sl2p_uniform_sobol_prosailD.LAI.Valid(index) ];
     dhat = [dhat ; round(repmat((Dlist(d)+Dlist(d+1))/2,length(index),1),1)];
       cgroup = [cgroup ; 1+0*index];
%   index = find((Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosailuniformLAI.D.Estime>=Dlist(d+1)).*((Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosailuniformLAI.D.Estime<1)));
%       y = [y ; Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosailuniformLAI.LAI.Valid(index) ];
%      dhat = [dhat ; round(repmat((Dlist(d)+Dlist(d+1))/2,length(index),1),1)+0.25];
%             cgroup = [cgroup ; 2+0*index];
%                   index = find((Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosail.D.Estime>=Dlist(d+1)).*((Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosail.D.Estime<1)));
%       y = [y ; Perf_Actual.NNT7.s2_sl2p_calmitsoy_mc_prosail.LAI.Valid(index) ];
%      dhat = [dhat ; round(repmat((Dlist(d)+Dlist(d+1))/2,length(index),1),1)+0.05];
%             cgroup = [cgroup ; 3+0*index];
     boxplot(y,round(dhat,2),'ColorGroup',cgroup,'Symbol','')
            hold on
 
xticklabels({'','0.0','','','0.1','','','0.2','','','0.3','','','0.4','','','0.5','','','0.6','','','0.7','','','0.8','','','0.9',''})
                xlabel('$$\hat{D}$$' ,'Interpreter','Latex' );
    ylabel('Cw');