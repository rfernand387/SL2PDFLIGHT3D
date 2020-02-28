function dbh =   getDBH(H,b,LB,UB,dbhmodel)
%%
% dbh - models dbh given height
switch dbhmodel
    case 1
        % http://flash.lakeheadu.ca/~chpeng/OFRI159.pdf
        dbh = -log(max(0.001,1-((H-1.3)/b(1))))./(b(2)*b(3));
    case 2
        % https://www.researchgate.net/publication/259399438_Height-diameter_equations_for_seventeen_tree_species_in_southwest_Oregon
        % https://ir.library.oregonstate.edu/downloads/3n2043903
        H = H * 3.28084;
        dbh = ((log(max(0.001,(H-4.5))-b(1))/(b(2))).^(b(3))) * 2.54;
    otherwise
        dbh =H/50;
end
dbh = max(LB,min(UB,dbh));
return
