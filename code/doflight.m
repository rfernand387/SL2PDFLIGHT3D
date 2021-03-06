function [R, D] =  doflight(targetdir,lambdas,lambdaref,N,Cab,Car,Ant,Cbp,Cw,Cdm,LIDFa,LIDFb,LAI,HsD,FRAC_COV,LF_SIZE,gamma,FRAC_BARK,FRAC_SEN,Exy,Ez,MIN_HT,MAX_HT,SOLAR_ZENITH,VIEW_ZENITH,VIEW_AZIMUTH,Rs)
%DOFLIGHT Sets up and runs a FLIGHT simulation in forward mode
%   Copies template directory to target directory first
%   Retuirns BRDF, D and black sky absorptance

% Default FLIGHT parameters
MODE = 'f';
ONED_FLAG = 3;
NO_PHOTONS = 100000;
FRAC_SEN = round(FRAC_SEN,2);
FRAC_BARK = round(FRAC_BARK,2);
FRAC_GRN = 1-FRAC_SEN-FRAC_BARK;
nosoilROUGH = 0;
AER_OPT = -0.00001;
CROWN_SHAPE	= 'e' ;
DBH = 0;

% adjust LAI to actually use shoots and as flight includes bark and
% senescent in TOTAL_LAI
TOTAL_LAI = LAI*(1+FRAC_BARK+FRAC_SEN)/gamma;
% set up foliage reflectance (we drop the last 100nm to comply with SL2P)
rededge = 710:790;
LRT=prospect_DB(N,Cab,Car,Ant,Cbp,Cw,Cdm);
% adjust rho and tau for shoot clumping
LRT(:,2) = LRT(:,2) .* (1/gamma) ./ ( 1 - LRT(:,2) .*(1-1/gamma));
LRT(:,3)= LRT(:,3) .* (1/gamma) ./ ( 1 - LRT(:,3).*(1-1/gamma));
[dummy,lambdalist1] = ismember(lambdas,LRT(:,1));
[dummy,lambdalist1re] = ismember(rededge,LRT(:,1));
[dummy,lambdalist2] = ismember(lambdas,Rs(:,1));
[dummy,lambdalist2re] = ismember(rededge,Rs(:,1));

% determine reflectance, transmittance for D
% in this case we base it on a reference lambda
Rs0= max(0,interp1(LRT(lambdalist1re(1:20),2)+LRT(lambdalist1re(1:20),3),Rs(lambdalist2re(1:20),2),0,'pchip'));
Rs1= 0;
LRTindex = find(LRT(:,1)==lambdaref);
if ( isempty(LRTindex) )
    LRTindex = length(LRT(:,1))
end
rho	=	LRT(LRTindex,2)./(LRT(LRTindex,2)+LRT(LRTindex,3));
tau	=	LRT(LRTindex,3)./(LRT(LRTindex,2)+LRT(LRTindex,3))-1e-4;
LRT = [ 350 1e-8 1e-8 ; LRT(lambdalist1,:)];
Rs = [ 350 Rs0 ; Rs(lambdalist2,: )];
leaf = [LRT ; 3500 rho tau];

% bark reflectance - very low cholorphyll and carotenides and 1 scattering
% Laurent et al.l 2010, 
% Estimating forest parameters from top-of-atmosphere radiance measurements
% using coupled radiative transfer models
LRT=prospect_DB(10,10,2,0,15,0,0.5); 
LRT = [ 350 1e-8 1e-8 ; LRT(lambdalist1,:)];
bark = [LRT(:,1) LRT(:,2)  ; 3500 rho ];
soil = [Rs ; 3500 Rs1 ];



% determine senescent foliage reflectance
% for now it equals leaf reflectance
sen = leaf;
NO_WVBANDS = length(soil(:,1));

% determine LAD using PRO4SAIL logic
% if 2-parameters LIDF: TypeLidf=1
if (LIDFb <=0)
    % LIDFa LIDF parameter a, which controls the average leaf slope
    % LIDFb LIDF parameter b, which controls the distribution's bimodality
    %	LIDF type 		a 		 b
    %	Planophile 		1		 0
    %	Erectophile    -1	 	 0
    %	Spherical 	   -0.35 	-0.15
    %   Spruce          -0.5    -0.5
    %	Uniform 0 0
    % 	requirement: |LIDFa| + |LIDFb| < 1	
    if ( LIDFa == 1) && (LIDFb == 0 )
        % Planophile leaf angle distribution
        LAD = [0.22 0.207 0.182 0.149 0.111 0.073 0.04 0.015 0.003];
    elseif ( LIDFa == -1) && (LIDFb == 0 )
        %  Erectophile leaf angle distribution
        LAD = [0.002 0.015 0.04 0.073 0.111 0.159 0.182 0.207 0.219 ];
    elseif ( LIDFa == -0.35) && (LIDFb == -0.15 )
        % Spherical leaf angle distribution
        LAD = [0.015 0.045 0.074 0.1 0.123 0.143 0.158 0.168 0.174];
    elseif ( LIDFa == -0.35) && (LIDFb == -0.15 )
        % Spruce leaf angle distribution
        LAD = [0.15 0.20 0.18 0.15 0.13 0.09 0.05 0.03 0.02];
    else
        % Uniform
        LAD = [ 1 1 1 1 1 1 1 1 1 ]/9;
    end
else
        %ellipsoidal with mean leaf angle LIDFa
        LAD = campbellFLIGHT(LIDFa);
end



% save the spectra for components

                        save([targetdir,'\SPEC\leaf.spec'], 'leaf','-ascii', '-double')
                        save([targetdir,'\SPEC\bark.spec'], 'bark','-ascii', '-double')
                        save([targetdir,'\SPEC\sen.spec'], 'sen','-ascii', '-double')
                        save([targetdir,'\SPEC\soil.spec'], 'soil','-ascii', '-double')
                        
% make the spectral files needed for flight 
                        fdat = fopen( [targetdir,'\in_flight.data'],'w');
                        fprintf(fdat,'%s\n',MODE);
                        fprintf(fdat,'%d\n',ONED_FLAG);
                        fprintf(fdat,'%f %f\n',SOLAR_ZENITH*180/pi,VIEW_ZENITH*180/pi);
                        fprintf(fdat,'%f %f\n',0,VIEW_AZIMUTH*180/pi);
                        fprintf(fdat,'%d\n',NO_WVBANDS);
                        fprintf(fdat,'%d\n',NO_PHOTONS);
                        fprintf(fdat,'%f\n',TOTAL_LAI);
                        fprintf(fdat,'%f %f %f\n',FRAC_GRN,FRAC_SEN,FRAC_BARK);
                        fprintf(fdat,'%f %f %f %f %f %f %f %f %f\n',LAD(1),LAD(2),LAD(3),LAD(4),LAD(5),LAD(6),LAD(7),LAD(8),LAD(9));
                        fprintf(fdat,'%f\n',nosoilROUGH);
                        fprintf(fdat,'%f\n',AER_OPT);
                        fprintf(fdat,'%f\n',LF_SIZE);
                        fprintf(fdat,'%f\n',FRAC_COV);
                        fprintf(fdat,'%s\n',CROWN_SHAPE);
                        fprintf(fdat,'%f  %f\n',Exy,Ez);
                        fprintf(fdat,'%f  %f\n',MIN_HT,MAX_HT);
                        fprintf(fdat,'%f\n',DBH);
                       fclose(fdat);
                        

                        % execute flight
                        currentdir = pwd;
                        cd(targetdir);
                        system('.\flight63auto');
                        cd(currentdir);
        
                        % copy output file - since the name is complex we need
                        % to determine it
                        dirlist = dir([targetdir,'\RESULTS\*.log']);
                        result = importfileauto([targetdir,'\RESULTS\',dirlist(1).name]);
                        R = [result.VarName5 result.VarName5 result.VarName3  result.VarName3 result.VarName6];
                        D = R(length(R)-1,1);
                        R= R(2:(length(R)-2),:);                    
                        delete([targetdir,'\RESULTS\*.*'])
        
                        return

