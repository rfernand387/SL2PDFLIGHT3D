function height =   getHeight(A,S,a,LB,UB,hmodel)
%%
% height - models dominant/codominant height given age and site index

switch(hmodel)
    case 1
        height = a(1)./(1-(1-a(1)./S).*(50./A).^a(2));
    case 3
        height = S.*(1-exp(-a(1).*A.^(a(2).*S.^a(3))))./(1-exp(-a(1).*a(4).^(a(2).*S.^a(3))));
    otherwise
        height = 1.3;
end
height = max(LB,min(UB,height));
return
