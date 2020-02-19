function [Law,Nb_Sims]=Create_Law_Var(Def_Base,Class,Soil,Law,Nb_Sims)
% create canopy and atmosphere parameter sampling laws
% Fred et Marie 01/08/2005
% Modif Fred Avril 2008
% Modif Marie septembre 2010: ajoût de la loi log normale, modification des
% contraintes sur les lois de co-distribution
% Richard July 2019

%% Initialisations
Var_Name=fieldnames(Def_Base.(['Class_' num2str(Class)]).Var_in); % nom des variables
Nb_Var=size(Var_Name,1); % nombre de variables


%% if we are dealing with TOA we separately sample the atmosphere first
%if strcmp( Def_Base.Toc_Toa , 'Toa')
    switch (Def_Base.(['Class_' num2str(Class)]).SamplingDesign)
        case {'LH'}
            h =  lhsdesign(Nb_Sims,4);
            h = h(randperm(Nb_Sims),:);
        case {'Sobel'}
            h = net(scramble(sobolset(4),'MatousekAffineOwen'),Nb_Sims);
        case {'Halton'}
            h = net(scramble(haltonset(4),'RR2'),Nb_Sims) ;
        case  {'FullOrthog'}
            for ivar = (Nb_Var-3):Nb_Var
                Nb_Class_Var(ivar-(Nb_Var-3)+1) = Def_Base.Class_1.Var_in.(Var_Name{ivar}).Nb_Classe;
            end
            h = (fullfact([Nb_Class_Var])-1 + rand(Nb_Sims,4)) ./ Nb_Class_Var ;
        otherwise %'MonteCarlo'
            h = rand(Nb_Sims,4);
    end
    
    % sample atmosphere
    for ivar = (Nb_Var-3):Nb_Var
        ivar
        Lb = Def_Base.(['Class_' num2str(Class)]).Var_in.(Var_Name{ivar}).Lb;
        Ub = Def_Base.(['Class_' num2str(Class)]).Var_in.(Var_Name{ivar}).Ub;
        P1 = Def_Base.(['Class_' num2str(Class)]).Var_in.(Var_Name{ivar}).P1;
        P2  = Def_Base.(['Class_' num2str(Class)]).Var_in.(Var_Name{ivar}).P2;
        pd = truncate(makedist(Def_Base.(['Class_' num2str(Class)]).Var_in.(Var_Name{ivar}).Distribution,P1,P2),Lb,Ub);
        Law.(Var_Name{ivar}) = icdf(pd,h(:,ivar-(Nb_Var-3)+1));
    end
    % reduce nb vars since we dont need atmosphere to be sampled more
    Nb_Var = Nb_Var - 4;
    
%end



%% Génération de la loi pour les spectres de sols
if ( isempty(Soil))
    I_Soil=repmat(1:size(Def_Base.(['Class_' num2str(Class)]).R_Soil.Refl,2),1,ceil(Nb_Sims./size(Def_Base.(['Class_' num2str(Class)]).R_Soil.Refl,2)));
    dum=randperm(length(I_Soil));
    Law.I_Soil=I_Soil(dum(1:Nb_Sims))';
else
    Law.I_Soil = Soil + zeros(Nb_Sims,1);
end



%% define sampling scheme (for full orthog we sample brute force)
switch (Def_Base.(['Class_' num2str(Class)]).SamplingDesign)
    case {'LH'}
        h =  lhsdesign(Nb_Sims,Nb_Var);
        h = h(randperm(Nb_Sims),:);
    case {'Sobel'}
        h = net(scramble(sobolset(Nb_Var),'MatousekAffineOwen'),Nb_Sims);
    case {'Halton'}
        h = net(scramble(haltonset(Nb_Var),'RR2'),Nb_Sims) ;
    case  {'FullOrthog'}
        for ivar = 1:Nb_Var
            Nb_Class_Var(ivar) = Def_Base.Class_1.Var_in.(Var_Name{ivar}).Nb_Classe;
        end
        h = (fullfact([Nb_Class_Var])-1 + rand(Nb_Sims,Nb_Var)) ./ Nb_Class_Var ;
    otherwise %'MonteCarlo'
        h = rand(Nb_Sims,Nb_Var);
end


%% make required truncated distribution for this variable
for ivar = 1:Nb_Var
    ivar
    Lb = Def_Base.(['Class_' num2str(Class)]).Var_in.(Var_Name{ivar}).Lb;
    Ub = Def_Base.(['Class_' num2str(Class)]).Var_in.(Var_Name{ivar}).Ub;
    P1 = Def_Base.(['Class_' num2str(Class)]).Var_in.(Var_Name{ivar}).P1;
    P2  = Def_Base.(['Class_' num2str(Class)]).Var_in.(Var_Name{ivar}).P2;
    pd = truncate(makedist(Def_Base.(['Class_' num2str(Class)]).Var_in.(Var_Name{ivar}).Distribution,P1,P2),Lb,Ub);
    Law.(Var_Name{ivar}) = icdf(pd,h(:,ivar));
    
    % adjust distribution range if not LAI
    if (~strcmp(Var_Name{ivar},'LAI'))
        
        % linear interpolation >=LAI_Conv
        %define bounds as a fn of LAI
        LbLAI = 0;
        UbLAI = Def_Base.(['Class_' num2str(Class)]).Var_in.Cab.LAI_Conv;
        %new lower bound
        VarMax =  Def_Base.(['Class_' num2str(Class)]).Var_in.(Var_Name{ivar}).min(2);
        VarMin = Def_Base.(['Class_' num2str(Class)]).Var_in.(Var_Name{ivar}).min(1);
        % squeeze variable between bounds limited to LAI_Conv
        if ( VarMin < VarMax )
            LbVar = min(VarMin + (Law.LAI - LbLAI)*(VarMax-VarMin)/(UbLAI-LbLAI),VarMax);
        else
            LbVar = max(VarMin + (Law.LAI - LbLAI)*(VarMax-VarMin)/(UbLAI-LbLAI),VarMin);
        end
        
        %new upper bound
        VarMax =  Def_Base.(['Class_' num2str(Class)]).Var_in.(Var_Name{ivar}).max(2);
        VarMin = Def_Base.(['Class_' num2str(Class)]).Var_in.(Var_Name{ivar}).max(1);
        % squeeze variable between bounds limited to LAI_Conv
        if ( VarMin < VarMax )
            UbVar = min(VarMin + (Law.LAI - LbLAI)*(VarMax-VarMin)/(UbLAI-LbLAI),VarMax);
        else
            UbVar = min(VarMin + (Law.LAI - LbLAI)*(VarMax-VarMin)/(UbLAI-LbLAI),VarMin);
        end
        
        %squeeze range between bounds
        Law.(Var_Name{ivar})  = LbVar + (Law.(Var_Name{ivar}) -Lb) .* (UbVar-LbVar) ./ (Ub-Lb);
    end
end

%% Create FLIGHT if required
% Make laws for each sim based on each species given age including
% probability of age given species
% assing zero probability to species with invalid within crown lai
% If all solutions are invalid we find the nearest valid solution and copy.

if ( strcmp(Def_Base.RTM,'FLIGHT') )
    
    % determine crown LAI
    LAI_Crown = Law.LAI ./ Law.Crown_Cover;
    
    % specify variable names
    Var_Name_FLIGHT = { 'p_Age' 'S' 'rL' 'gamma' 'fbark' 'fsen' 'H' 'sigma_H' 'dbh' 'rxy' 'rz'}
    nVars_FLIGHT = length(Var_Name_FLIGHT);
    
    % determine prob of age given each species entry 
    nspecies = length(Def_Base.Class_1.FLIGHT)
     
    % make array for all sims, all species, all flight vars
    LawsFlight = rand(Nb_Sims, nspecies, nVars_FLIGHT);
    
    % simulate each species
    for n = 1:nspecies
        
            % determine probability of age
            Distribution = Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).Age_Distn;
            P1 = Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).Age_P1;
            P2 = Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).Age_P2;
            Lb = Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).Age_LB;
            Ub = Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).Age_UB;
            LawsFlight(:,n,1) = pdf(truncate(makedist(Distribution,P1,P2),Lb,Ub),Law.Age);
            LawsFlight(:,n,1) = LawsFlight(:,n,1) .* ( LAI_Crown >= Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).LAI_min) .* (LAI_Crown <= Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).LAI_max);
              
                            

            % determine site index based on provided pdf 
            Distribution = Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).S_Distn;
            P1 = Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).S_P1;
            P2 = Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).S_P2;
            Lb = Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).S_LB;
            Ub = Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).S_UB;
            LawsFlight(:,n,2) = icdf(truncate(makedist(Distribution,P1,P2),Lb,Ub),LawsFlight(:,n,2));            

             % determine leaf radius based on provided pdf 
            Distribution = Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).rl_Distn;
            P1 = Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).rl_P1;
            P2 = Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).rl_P2;
            Lb = Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).rl_LB;
            Ub = Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).rl_UB;
            LawsFlight(:,n,3) = icdf(truncate(makedist(Distribution,P1,P2),Lb,Ub),LawsFlight(:,n,3)); 
 
            % determine leaf radius based on provided pdf 
            Distribution = Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).gamma_Distn;
            P1 = Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).gamma_P1;
            P2 = Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).gamma_P2;
            Lb = Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).gamma_LB;
            Ub = Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).gamma_UB;
            LawsFlight(:,n,4) = icdf(truncate(makedist(Distribution,P1,P2),Lb,Ub),LawsFlight(:,n,4)); 
 
            % determine leaf radius based on provided pdf 
            Distribution = Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).gamma_Distn;
            P1 = Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).gamma_P1;
            P2 = Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).gamma_P2;
            Lb = Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).gamma_LB;
            Ub = Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).gamma_UB;
            LawsFlight(:,n,5) = icdf(truncate(makedist(Distribution,P1,P2),Lb,Ub),LawsFlight(:,n,5));             
 
            % determine fraction of bark based on provided pdf 
            Distribution = Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).fbark_Distn;
            P1 = Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).fbark_P1;
            P2 = Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).fbark_P2;
            Lb = Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).fbark_LB;
            Ub = Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).fbark_UB;
            LawsFlight(:,n,6) = icdf(truncate(makedist(Distribution,P1,P2),Lb,Ub),LawsFlight(:,n,6)); 
  
            % determine fraction of senescent based on provided pdf 
            Distribution = Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).fsen_Distn;
            P1 = Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).fsen_P1;
            P2 = Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).fsen_P2;
            Lb = Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).fsen_LB;
            Ub = Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).fsen_UB;
            LawsFlight(:,n,7) = icdf(truncate(makedist(Distribution,P1,P2),Lb,Ub),LawsFlight(:,n,7)); 
 
            % determine height based on age and site index and height model
            LawsFlight(:,n,8) = getHeight(Law.Age,LawsFlight(:,n,2),...
                            [Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).H_a0 ,...
                            Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).H_a1 ,...
                            Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).H_a2], ...
                            Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).H_LB , ...
                            Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).H_UB , ...
                            Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).H_model); 
            LawsFlight(:,n,9) = LawsFlight(:,n,9)*0 + Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).sigma_H; 

            % determine dbh based on height using dbh model
            LawsFlight(:,n,10) = getDBH(LawsFlight(:,n,8), ...
                           [Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).dbh_b0 ,...
                            Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).dbh_b1 ,...
                            Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).dbh_b2], ...
                            Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).dbh_LB , ...
                            Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).dbh_UB , ...
                            Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).dbh_model); 
  
              % determine rxy and rz based on dbh
            LawsFlight(:,n,11) = Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).rxy_c0 + LawsFlight(:,n,10).*Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).rxy_c1;
            LawsFlight(:,n,12) = min(0.,max(0.2,Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).rz_d0 + LawsFlight(:,n,10).*Def_Base.(['Class_' num2str(Class)]).FLIGHT(n).rz_d1));

            
    end
    
    % identify sims where no species fit valid crown lai and replace
    total_prob = sum(LawsFlight(:,:,1),2);
    valid = find(total_prob>0);
    invalid = find(total_prob == 0);
    LawsFlight(invalid,:,:) = LawsFlight(valid(ceil(rand(length(invalid),1)*length(valid))),:,:);
    total_prob = sum(LawsFlight(:,:,1),2);
    % choose a species based on cumulative normalzied probability
    LawsFlight(:,:,1) = cumsum(LawsFlight(:,:,1) ./ repmat(total_prob,1,nspecies),2);
    ind = 5-sum(LawsFlight(:,:,1) > repmat(rand(Nb_Sims,1),1,nspecies),2 );
    
    % assign law for selected species to each sim
    Law.rleaf = LawsFlight(sub2ind(size(LawsFlight),(1:length(ind))',ind,4+0*ind));
    Law.gamma = LawsFlight(sub2ind(size(LawsFlight),(1:length(ind))',ind,5+0*ind));
    Law.fbark = LawsFlight(sub2ind(size(LawsFlight),(1:length(ind))',ind,6+0*ind));
    Law.fsen = LawsFlight(sub2ind(size(LawsFlight),(1:length(ind))',ind,7+0*ind));
    Law.H  = LawsFlight(sub2ind(size(LawsFlight),(1:length(ind))',ind,8+0*ind));
    Law.dbh =  LawsFlight(sub2ind(size(LawsFlight),(1:length(ind))',ind,10+0*ind));
    Law.rxy =  LawsFlight(sub2ind(size(LawsFlight),(1:length(ind))',ind,11+0*ind));
    Law.rz =  LawsFlight(sub2ind(size(LawsFlight),(1:length(ind))',ind,12+0*ind));
    Law.Max_ht = max(1.3,Law.H .*(1-Law.rz) +  LawsFlight(sub2ind(size(LawsFlight),(1:length(ind))',ind,9+0*ind)));
    Law.Min_ht = max(1.3,Law.H.*(1-Law.rz) -  LawsFlight(sub2ind(size(LawsFlight),(1:length(ind))',ind,9+0*ind)));
    Law.rz = (Law.H .*(1-Law.rz))/2;
end
%% Randomisation des cas simulés (pour la sélection entre les différentes bases d'apprentissage, hyper et validation)
% on laisse les angles de côtés pour garder les conditions d'écartement du
% hot spot r&élaisées dans Law_obs
I_Rand=randperm(length(Law.LAI));
for ivar=1:length(Var_Name)
    Law.(Var_Name{ivar})(1:Nb_Sims)=Law.(Var_Name{ivar})(I_Rand(1:Nb_Sims));
end

