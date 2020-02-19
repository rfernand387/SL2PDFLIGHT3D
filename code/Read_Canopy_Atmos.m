function Def_Base =  Read_Canopy_Atmos(Def_Base,Class)
%% Definition of class parameters for simulation database creation.
% Fred 12/12/2005
% Modif Fred Septembre 2007
% Modif Avril 2008
% Fred Mai 2008
% Richard July 2019

%% Initialisations
Var={'LAI' 'ALA' 'Crown_Cover' 'HsD' 'N' 'Cab' 'Cdm' 'Cw_Rel' 'Cbp' 'Bs' 'Age' 'P' 'Tau550' 'H2O' 'O3'};
Champ={'Lb' 'Ub' 'P1' 'P2' 'Nb_Classe'};


%% NUmber of SImulations
[x,y]= xlsread([Def_Base.File_XLS '.xls'],['Canopy_Atmos_Class_' num2str(Class)],'G17');
Def_Base.(['Class_' num2str(Class)]).Nb_Sims = x;

%% Select the class to be used												
[x,y]= xlsread([Def_Base.File_XLS '.xls'],['Canopy_Atmos_Class_' num2str(Class)],'C18');
Def_Base.(['Class_' num2str(Class)]).ClassNumber=x;

%% Name of the class selected
[x,y]= xlsread([Def_Base.File_XLS '.xls'],['Canopy_Atmos_Class_' num2str(Class)],'C19');
Def_Base.(['Class_' num2str(Class)]).ClassName=char(y);

%% Asymptotic value of fAPAR reached for infinite LAI and used as a threshold in the LAI_fAPAR relationship												
[x,y]= xlsread([Def_Base.File_XLS '.xls'],['Canopy_Atmos_Class_' num2str(Class)],'C20');
Def_Base.(['Class_' num2str(Class)]).LAI_fAPAR_streamline=x;

%% Maximum LAI value authorized for the 'pure' vegetation component												
[x,y]= xlsread([Def_Base.File_XLS '.xls'],['Canopy_Atmos_Class_' num2str(Class)],'C21');
Def_Base.(['Class_' num2str(Class)]).LAI_Max_Local=x;

%% Method used to sample canopy parameters												
[x,y]= xlsread([Def_Base.File_XLS '.xls'],['Canopy_Atmos_Class_' num2str(Class)],'C22');
Def_Base.(['Class_' num2str(Class)]).SamplingDesign=char(y);

%% Provide the path and file name corresponding to the soil reflectance spectra used												
[x,y]= xlsread([Def_Base.File_XLS '.xls'],['Canopy_Atmos_Class_' num2str(Class)],'C23');
Def_Base.(['Class_' num2str(Class)]).R_Soil.File=char(y);
load(Def_Base.(['Class_' num2str(Class)]).R_Soil.File);
Def_Base.(['Class_' num2str(Class)]).R_Soil.Lambda = R_Soil.Lambda;
Def_Base.(['Class_' num2str(Class)]).R_Soil.Refl = R_Soil.Refl;

%% Provide the path and file name corresponding to reflectance spectra for streamlining the learning data base  through reflectance mismatch
[x,y]= xlsread([Def_Base.File_XLS '.xls'],['Canopy_Atmos_Class_' num2str(Class)],'C24');
Def_Base.(['Class_' num2str(Class)]).File_Mismatch=char(y);
if ( isempty(Def_Base.(['Class_' num2str(Class)]).File_Mismatch) )
    Def_Base.(['Class_' num2str(Class)]).Mismatch_Filtering='N';
else
    Def_Base.(['Class_' num2str(Class)]).Mismatch_Filtering='Y';
    load(Def_Base.(['Class_' num2str(Class)]).File_Mismatch);
end

%% Define parent class from whcih simulations can be used											
[x,y]= xlsread([Def_Base.File_XLS '.xls'],['Canopy_Atmos_Class_' num2str(Class)],'C25');
Def_Base.(['Class_' num2str(Class)]).ParentClassNumber=x;


%% Select 'yes' if filtering the data base using the reflectance mismatch file
[x,y]= xlsread([Def_Base.File_XLS '.xls'],['Canopy_Atmos_Class_' num2str(Class)],'C15');
Def_Base.(['Class_' num2str(Class)]).Mismatch_Filtering=char(y);


%% Les autres variables
[x,y]= xlsread([Def_Base.File_XLS '.xls'],['Canopy_Atmos_Class_' num2str(Class)],'C2:O16');
for ivar=1:size(x,1)
    for i_Champ=1:size(Champ,2)
        Def_Base.(['Class_' num2str(Class)]).Var_in.(Var{ivar}).(Champ{i_Champ})= x(ivar,i_Champ);
    end
    %Def_Base.Var_in.(['Class_' num2str(Class)]).(Var{ivar}).Distribution=char(y(ivar,6));
    Def_Base.(['Class_' num2str(Class)]).Var_in.(Var{ivar}).Distribution=char(y(ivar,1));
    % lecture des contraintes sur l'évolution de la variable en fonction du
    % LAI
    Def_Base.(['Class_' num2str(Class)]).Var_in.(Var{ivar}).LAI_Conv=x(ivar,7);
    Def_Base.(['Class_' num2str(Class)]).Var_in.(Var{ivar}).min=[x(ivar,8) x(ivar,10)];
    Def_Base.(['Class_' num2str(Class)]).Var_in.(Var{ivar}).max=[x(ivar,9) x(ivar,11)];
end    

%% Read FLIGHT paraneters if required
if ( strcmp(Def_Base.RTM,'FLIGHT') )
    ChampNum = {'Age_LB','Age_UB','Age_P1','Age_P2','N_LB','N_UB','N_P1', ...
        'N_P2','S_LB','S_UB','S_P1','S_P2','rl_LB','rl_UB','rl_P1','rl_P2',...
        'gamma_LB','gamma_UB','gamma_P1','gamma_P2','fbark_LB','fbark_UB','fbark_P1','fbark_P2', ...
        'fsen_LB','fsen_UB','fsen_P1','fsen_P2','H_LB','H_UB','H_a0','H_a1','H_a2','sigma_H','H_model', ...
        'dbh_LB','dbh_UB','dbh_b0','dbh_b1','dbh_b2','dbh_model','rxy_c0','rxy_c1','rz_d0','rz_d1','LAI_min','LAI_max' };
    ChampTxt = {'Age_Distn','N_Distn','S_Distn','rl_Distn','gamma_Distn','fbark_Distn', 'fsen_Distn' }; 
    numericindices = [3,4,5,6,8,9,10,11,13,14,15,16,18,19,20,21,23,24,25,26,28,29,30,31,33,34,35,36,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56]-2;
    textindices = [1,6,11,16,21,26,31];
    [x,y,z]= xlsread([Def_Base.File_XLS '.xls'],['FLIGHT_Class_' num2str(Class)],'c2:bf5');
    for ivar = 1:size(z,1)
        for i_champ = 1:length(numericindices)
            Def_Base.(['Class_' num2str(Class)]).FLIGHT(ivar).(ChampNum{i_champ})= x(ivar,numericindices(i_champ));
        end
        for i_champ = 1:length(textindices)
            Def_Base.(['Class_' num2str(Class)]).FLIGHT(ivar).(ChampTxt{i_champ})= char(y(ivar,textindices(i_champ)));
        end
        
    end
end
return
