function status = SL2PD(Version_Name, Overwrite, Debug)
% Simplified Level 2 Processor D
%   status = SL2PD(Version_Name,Overwrite Debug) returns status of SL2PD
%   when provided with a parameter file corresponding to Version_Name.
%
% Inputs
%
% Version_Name :  Name of Processor Parameter File.
% {Overwrite} : 1 overwriting of existing class database or regressions
% {Debug} : Debug level,  1 for debug output
%
% Outputs
%
% status :  1 no exceptions, 0 otherwise
%
% Created: Fred Baret and Marie Weiss, January 2006
% Modified: Richard July 2019
%% Initialisation of Matlab Environment
% .\CODE holds matlab source code and other libraries and executables
%   ..\Tools holds generic MALTAB source code and libraries
%
% .\DATA holds data files requires by files in .\code
%    ..\Filtres_Smac_SL2PD.mat - spectral response functions and smac coefficients
%    ..\struct_Orbito_Sensor.m - code that generates orbital parameters
%
addpath(genpath('.\CODE'));
addpath(genpath('.\DATA'));
tic


%% Definition of Dataset Name ,Regression Algorithm, Validation Database
% Read options for current simulation
Def_Base =  Read_Start_Data(Version_Name)

% Read global description of calibration database
Def_Base = Read_Learning_Data(Def_Base);

% Création des directory 'Report'
Def_Base.Report_Dir=fullfile('.',['Report_' Def_Base.Name]);
if ~isdir(Def_Base.Report_Dir)
    mkdir(Def_Base.Report_Dir)
else
    if (Debug)
        disp('Report Directory Exists ')
    end
end

% Identification of directory 'Validation'
Def_Base.Validation_Dir=fullfile('.',['Report_' Def_Base.Validation_Name]);
if ~isdir(Def_Base.Validation_Dir)
    if (Debug)
        disp('No Validation Database Found, Validation Skipped ')
    end
    Def_Base.Validation_Dir= [];
end


%% Define regression algorithm and make a copy of the definition
Def_Base = Read_Alg_Archi(Def_Base);
if (Debug)
    disp(['Regression Algorithm ',Def_Base.Algorithm_Name])
end


%% Create sensor sampling law for maximum number of simulations if it does not exist
% Verify the size of the created Sensor sampling Law is same as maximum
% number simulations
try
    load(fullfile(Def_Base.Report_Dir,'Law.mat'), 'Law','-mat')
catch
    if (Debug)
        disp('Creating distributions of observational conditions  ')
    end
    Def_Base = Read_Observations(Def_Base); % définition du capteur et des observations
    Law=Create_Law_Obs(Def_Base); % creation des distributions des conditions d'observation
end
if (length(Law.View_Zenith) ~= Def_Base.Max_Sims)
    if (Debug)
        disp('Sensor sampling does not match maximum required simulations.');
    end
    status = 0;
    return
end



%% Save definitionn and sensor sampling Law  globally
save(fullfile(Def_Base.Report_Dir,'Law.mat'), 'Law','-mat')
save(fullfile(Def_Base.Report_Dir,'Def_Base.mat'), 'Def_Base','-mat')

%% Loop through all classes
for Class = 1:Def_Base.Num_Classes
    
    
    %% ensure class database if present
    try
        %% load current database if it exists and overwrite not specified
        if ( ~Overwrite)
            % load the current class data base if it exists
            load(fullfile([Def_Base.Report_Dir '\Class_' num2str(Class)],[char(Def_Base.Name) '_inout.mat']),'-mat')
        else
            % force error to make the database
            ME = MException('MyComponent:noSuchVariable', ...
                'Variable %s not found', inputstr);
            throw(MException('Dummy'));
        end
    catch
        %% Produce this class
        
        % Make directories for this class
        mkdir([Def_Base.Report_Dir '\Class_' num2str(Class)])
        mkdir([Def_Base.Report_Dir '\Class_' num2str(Class) '\Learn_Data_Base'])
        
        % Création des distributions de la base d'apprentissage
        disp(['Reading Learning data base information for Class ' num2str(Class)])
        Def_Base = Read_Canopy_Atmos(Def_Base,Class); % definition des distributions des variables d'entrée des modeles de la surface et de l'atmosphère
        
        % graphiques de définition du sol et des capteurs
        Plot_Sol_Bandes(Def_Base,Class);
        
        % save definition for this class and globally
        save(fullfile(Def_Base.Report_Dir,'Def_Base.mat'), 'Def_Base','-mat')
        save(fullfile([Def_Base.Report_Dir '\Class_' num2str(Class)],[char(Def_Base.Name) '.mat']),'-mat')
        
        % create and save canopy and atmsopeher parameter sampling Law for this class
        disp(['Creating distributions of input variables for Class ' num2str(Class)])
        Nb_Sims = Def_Base.(['Class_' num2str(Class)]).Nb_Sims;
        [Law]=Create_Law_Var(Def_Base,Class,[],Law,Nb_Sims);
        save(fullfile([Def_Base.Report_Dir '\Class_' num2str(Class)],[char(Def_Base.Name) '.mat']),'-mat')
        
        % simulate using Law and specified RTM
        [Input,Output,Law] = Build_Database( Def_Base, Law, Class,Def_Base.CopyFlag)
        Plot_Law(Def_Base,Law,[],Class) % Edition des histogrammes des lois
        save(fullfile([Def_Base.Report_Dir '\Class_' num2str(Class)],[char(Def_Base.Name) '_inout.mat']),'-mat')
        
        % cluster Laws for block training
        Def_Base.(['Class_' num2str(Class)]).Cats = 1:length(Law.LAI);
        % block training by clustering some of the laws in blocks of 100 samples
        nclus = ceil(length(Cats)/100);
        abc = (([ Law.ALA Law.Cab Law.N Law.Cdm Law.Cw_Rel Law.Bs])');
        Def_Base.(['Class_' num2str(Class)]).Cats = kmeans(abc',nclus, 'Replicates',5,'MaxIter',1000);
        save(fullfile([Def_Base.Report_Dir '\Class_' num2str(Class)],[char(Def_Base.Name) '.mat']),'-mat')
        save(fullfile(Def_Base.Report_Dir,'Def_Base.mat'), 'Def_Base','-mat')
        
        
        % plot the noise free inputs amd outputs for this class
        Plot_Matrix_InOut(Def_Base, Law, Input_Noise, Output,Class);
        
        % [Def_Base,Input_Noise]=Streamline_LAI_fAPAR(Def_Base,Output,Input_Noise,Law,Class); % Relations LAI/fAPAR
        
    end
    
    
    
    
    %% calibrate and/or validate regression algorithm if requested
    try ( ~isempty(Def_Base.(Def_Base.Algorithm_Name).Method) )
        %% define regression method
                            P = (Def_Base.(Def_Base.Algorithm_Name).Archi.Partition_Name); 
        try
            %% check if method already exists
            load(fullfile([Def_Base.Report_Dir '\Class_' num2str(Class)],[char(Def_Base.Name) '.mat']),'-mat','Results' );
            if ( Debug && ~isempty(Results.(Def_Base.Algorithm_Name).(P)))
                disp(['Loaded results for ' Def_Base.Algorithm_Name '.' P  ' for Class ' num2str(Class)]);
            end
        catch
            %% calibrate a new regression
            if ( Debug )
                disp(['Calibrating ' Def_Base.Algorithm_Name '.' P  ' for Class ' num2str(Class)]);
            end
            
            % add noise to the input data
            Input_Noise=Add_Noise_Input(Def_Base,Input,Class);
            
            % plot the noisy inputs amd outputs for this class and regression
            Plot_Matrix_InOut(Def_Base, Law, Input_Noise, Output,Class);
            
            switch Def_Base.(Def_Base.Algorithm_Name).Method
                case {'NNT}'
                        %% determine if we are cascading
                        if ( strcmp(P,'Single')  )
                        %% not cascading
                        [Results.(Def_Base.Algorithm_Name).(P),Perf_Theo.(Def_Base.Algorithm_Name).(P)]= Train_NNT_Sim_batch([Def_Base.Var_out],Input_Noise,Output,Def_Base,Class,5);
                        
                        else
                            %% cascading
                            [Results.(Def_Base.Algorithm_Name).Single,Perf_Theo.(Def_Base.Algorithm_Name).Single]= Train_NNT_Sim_batch(P,Input_Noise,Output,Def_Base,Class,5);
                            [Pest] = Predict_NNT_Sim_batch(P, Input_Noise, Results.(Def_Base.Algorithm_Name).Single,Class,Def_Base.(Class).Cats,unique(Def_Base.(Class).Cats),[])';
                            Input_Noise.P = Pest.(P);
                            Plist = (min(Input_Noise.(P))):Results.(P).RMSE(3):(max(Input_Noise.(P)));
                            Plist(1) = min(min(Input_Noise.(P)),Plist(1));
                            Plist(length(Plist)) = max(max(Input_Noise.(P)),Plist(length(Plist)) );
                            [Results.(Def_Base.Algorithm_Name).(P),Perf_Theo.(Def_Base.Algorithm_Name).(P)]= Train_NNT_Sim_batch_P([Def_Base.Var_out], Input_Noise,Output,Def_Base,Class,5,Plist);
                        end
                otherwise
                    if ( Debug )
                        disp('Invalid Regression');
                    end
                    status = 0;
                    return
                    
            end
            

        end
            
        %% perform cross validation
                            try
                        load(fullfile([Def_Base.Validation_Dir '\Class_' num2str(Class)],[char(Def_Base.Name) '_inout.mat']),'-mat','Input');
                        load(fullfile([Def_Base.Validation_Dir '\Class_' num2str(Class)],[char(Def_Base.Name) '_inout.mat']),'-mat','Output');
                         add noise to the input validation data
                        Input_Noise=Add_Noise_Input(Def_Base,Input,Class);
        
%                         do validation and plot results
                        [ResultsActual,Perf_Actual]= Validate( [Def_Base.Var_out],Input_Noise,Output,Class,Results.(Def_Base.Algorithm_Name));
                        Plot_Perfo_Theo(Def_Base,ResultsActual,Perf_Actual,Class,[Def_Base.Validation_name '_' Def_Base.Algorithm_Name],'');
              
        end
    catch
        if (Debug)
            disp(['Class_' num2str(Class) ' created. No regression algorithm selected.']);
        end
    end
    
            
        
        %     calibrate and cross validate regression method
        %
        %             save the networks in class specific results file
        %             save(fullfile([Def_Base.Report_Dir '\Class_' num2str(Class)],[char(Def_Base.Name) '.mat']),'-mat')
        %                         save(fullfile(Def_Base.Report_Dir,'Def_Base.mat'), 'Def_Base','-mat')
        %
        %             perform cross-validation
        %             try
        %                 load(fullfile([Def_Base.Validation_Dir '\Class_' num2str(Class)],[char(Def_Base.Name) '_inout.mat']),'-mat','Input');
        %                 load(fullfile([Def_Base.Validation_Dir '\Class_' num2str(Class)],[char(Def_Base.Name) '_inout.mat']),'-mat','Output');
        %
        %                 add noise to the input validation data
        %                 Input_Noise=Add_Noise_Input(Def_Base,Input,Class);
        %
        %                 do validation and plot results
        %                 [ResultsActual,Perf_Actual]= Validate( [Def_Base.Var_out],Input_Noise,Output,Class,Results,[],[]);
        %                 Plot_Perfo_Theo(Def_Base,ResultsActual,Perf_Actual,Class,[Def_Base.Validation_name '_' Def_Base.Algorithm_Name],'');
        %
        %
        %                 % incertitudes based on the validation results
        %                 [ResultsActualI,Perf_ActualI]=Incertitudes([Def_Base.Var_out],Def_Base,Results,Perf_Theo,Class,Cats,5);
        %                 Plot_Perfo_Theo(Def_Base,ResultsActualI,Perf_ActualI,Class,['Incertitudes' Def_Base.Validation_name '_' Def_Base.Algorithm_Name],'-Error');
        %
        %                 Add_NNT_XlsFile(Def_Base,Results,Class);
        %                 save(fullfile([Def_Base.Report_Dir '\Class_' num2str(Class)],[Def_Base.Validation_name '_' Def_Base.Algorithm_Name '.mat']),'-mat')
        %                 save(fullfile(Def_Base.Report_Dir,['Def_Base' char(Def_Base.Algorithm_Name) '.mat']), 'Def_Base','-mat')
        %             catch
        %                 disp(['Validation directory not found for class',num2str(class)])
        %                 status = 0;
        %             end
        %         case {'NNTP'}
        %             run unconstrained nnet to estimate d (var 7 in this case)
        %             [Results,Perf_Theo]= Train_NNT_Sim_batch([Def_Base.Var_out],Input_Noise,Output,Def_Base,Class,Cats,5);
        %             Plot_Perfo_Theo(Def_Base,Results,Perf_Theo,Class,'Baseline','');
        %
        %             predict P for all inputs, the intervals for D are based on its rmse
        %             prediction and will span +/-1 interval of each centre interval
        %             P = Def_Base.(Def_Base.(['Class_' num2str(class)]).P);
        %             [Pest] = Predict_NNT_Sim_batch(P,Class,Cats,unique(Cats),[])';
        %             Input_Noise.P = Pest.(P);
        %             Plist = (min(Input_Noise.(P))):Results.(P).RMSE(3):(max(Input_Noise.(P)));
        %             Plist(1) = min(min(Input_Noise.(P)),Plist(1));
        %             Plist(length(Plist)) = max(max(Input_Noise.(P)),Plist(length(Plist)) );
        %             [ResultsP,Perf_TheoP]= Train_NNT_Sim_batch_P([Def_Base.Var_out], Input_Noise,Output,Def_Base,Class,Cats,5,Plist);
        %             Plot_Perfo_Theo(Def_Base,ResultsP,Perf_TheoP,Class,[P '_constr'],'');
        %
        %             save the networks
        %             save(fullfile([Def_Base.Report_Dir '\Class_' num2str(Class)],[char(Def_Base.Name) '.mat']),'-mat')
        %             save(fullfile(Def_Base.Report_Dir,'Def_Base.mat'), 'Def_Base','-mat')
        %
        %             load the validation database
        %             load(fullfile([Def_Base.Validation_Dir '\Class_' num2str(Class)],[char(Def_Base.Name) '_inout.mat']),'-mat','Input');
        %             load(fullfile([Def_Base.Validation_Dir '\Class_' num2str(Class)],[char(Def_Base.Name) '_inout.mat']),'-mat','Output');
        %
        %             add noise to the input validation data
        %             Input_Noise=Add_Noise_Input(Def_Base,Input,Class);
        %
        %             do validation and plot results
        %             [ResultsActual,Perf_Actual]= Validate( [Def_Base.Var_out],Input_Noise,Output,Class,Results,P,ResultsP);
        %             Plot_Perfo_Theo(Def_Base,ResultsActual,Perf_Actual,Class,[Def_Base.Validation_name '_' Def_Base.Algorithm_Name],'');
        %
        %             % incertitudes based on the validation results
        %             [ResultsActualI,Perf_ActualI]=Incertitudes([Def_Base.Var_out],Def_Base,Results,Perf_Theo,Class,Cats,5);
        %             Plot_Perfo_Theo(Def_Base,ResultsActualI,Perf_ActualI,Class,['Incertitudes' Def_Base.Validation_name '_' Def_Base.Algorithm_Name],'-Error');
        %
        %             Add_NNT_XlsFile(Def_Base,Results,Class);
        %             save(fullfile([Def_Base.Report_Dir '\Class_' num2str(Class)],[Def_Base.Validation_name '_' Def_Base.Algorithm_Name '.mat']),'-mat')
        %             save(fullfile(Def_Base.Report_Dir,['Def_Base' char(Def_Base.Algorithm_Name) '.mat']), 'Def_Base','-mat')
        %         otherwise
        %             if (Debug)
        %                 disp('No regression algorithm selected.')
        %             end
        %     end
        %
    end
    
    
    toc

















