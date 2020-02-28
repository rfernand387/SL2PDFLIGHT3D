function rxy =   getrxy(D,c,LB,UB,rxymodel)
%%
% rky - models rxy given dbh
switch dbhmodel
    case 1
        rxy = c(1)+c(2).*D;
    case 2
        rxy = c(1).*(D.^c(2));
    otherwise
        rxy = 1.0;
end
rxy= max(LB,min(UB,rxy));
return
