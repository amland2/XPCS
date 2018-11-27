function [g2] = KWW(t,par)
g2_plat=par(1);
Tau=par(2);
Beta=par(3);
g2=1+g2_plat.*(exp(-2.*(t./Tau).^Beta));
end