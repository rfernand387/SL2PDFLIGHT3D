function dbh =   getDBH(H,b,LB,UB,dbhmodel)
%%
% dbh - models dbh given height
switch dbhmodel
    case 1
dbh = -log(max(0.001,1-((H-1.3)/b(1))))./(b(2)*b(3));
    otherwise
        dbh =0;
end
dbh = max(LB,min(UB,dbh));
return
