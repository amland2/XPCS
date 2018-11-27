function [fit2data,contrast,tau,exponent,contrast_err,tau_err,exponent_err] = fitstrchexp(varargin)

delay   = varargin{1};
g2      = varargin{2};
g2Err   = varargin{3};

xdata=double(delay);
ydata=double(g2);
edata=double(g2Err);

if (numel(xdata) > 5)
        
        % kludge to avoid NaN at last y point in calc'ed data
        baseline = 1;
        
        contrast = sum(ydata(1:4)) / numel(ydata(1:4))      ...
            - baseline                                    ; % take the average of some data points minus baseline as contrast
        contrast = max(0.01, contrast)                         ; % make sure the contrast is positive
        gamma    = 1 / xdata(floor(numel(xdata)/2))            ; % put the starting gamma value into the middle of the time axis
        if ( contrast > 0.01 )                                  % standard correlation function (some decay)
            corrcase = 0                                       ;
        end
        else
        contrast = 0.3                                         ; % emergency default contrast start parameter
        gamma    = 1.0                                         ; % emergency default gamma start parameter
        corrcase = 0                                           ;
        end
    exponent = 1.0                                             ;
    
    
    start2 = [contrast gamma exponent]                ;
    if ( corrcase == 0 )
        low2   = [contrast/5 gamma/1e03 exponent/3] ;
        high2  = [contrast*5 gamma*1e03 exponent*3] ;
    end
    
    clear contrast gamma exponent corrcase;
    
    % --- perform fit & calculated best fit at data points
    opt = optimset ('Display','off','MaxIter',500,          ...
        'MaxFunEvals',2000,'TolX',1.0e-15)         ;
    edata(isnan(edata))=1; %kludge to fix NaN in g2Err
    [fit2,sig2,~,~,fit2data] =           ...
        myeasyfit(@stretchedExponent1,xdata,ydata,edata    ...
        ,start2,low2,high2,opt)                     ;
    
    % --- store some results (parameters,resnorm,...)                              
    contrast = fit2(1);
    gamma = fit2(2);
    tau=1./gamma;
    exponent = fit2(3);
    contrast_err = sig2(1);
    gamma_err = sig2(2);
    exponent_err = sig2(3);
    tau_err=gamma_err./gamma.^2;
end

function F = stretchedExponent1(param,xdata)
%%%used with the standard xpcsgui fitting routine
% ---
% --- x(1) : Baseline
% --- x(2) : Contrast
% --- x(3) : Gamma = 1/tau
% --- x(4) : Stretching Exponent
% ---
F = 1 + param(1) * exp( - 2 * (param(2) * xdata).^param(3) )                        ; % this assumes a homodyne detection scheme
end
