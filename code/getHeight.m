function height =   getHeight(A,S,a,LB,UB,hmodel)
%%
% height - models dominant/codominant height given age and site index

switch(hmodel)
    case 1
        height = a(1)./(1-(1-a(1)./S).*(50./A).^a(2));
    case 2
        height = 1.3 + (S-1.3) .* (1+exp(a(1)-a(2)*log(50)-a(3)).*log(S-1.3))./(1+exp(a(1)-a(2)*log(A)-a(3)).*log(S-1.3));
    otherwise
        height = 1.3;
end
height = max(LB,min(UB,height));
return
