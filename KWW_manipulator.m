global t
global par
t=logspace(0,7,200);
par=[0.055 30240 1.681];
global g2
g2=KWW(t,par);
f = figure;
ax = axes('Parent',f,'position',[0.13 0.39  0.77 0.54]);
h = semilogx(t,g2);


rerun_callback = 1;
b = uicontrol('Parent',f,'Style','slider','Position',[81,54,419,23],...
              'value',par(1), 'min',0, 'max',0.1,'Callback', @pushbutton1_Callback);     

function pushbutton1_Callback(hObject, eventdata, handles)
    par(1)=hObject.Value;
    g2=KWW(t,par);
    refreshdata(h);
    end