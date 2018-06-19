function obslugabuttondown(akcja)
    % counter=getappdata(ax.fig,'axes_counter');
%do things...

ibaza=0;
switch akcja
case 'baza'
  
   if ibaza == 0
    set(gcbo,'LineWidth',3 - get(gcbo,'LineWidth'));
   ibaza = 1
   else
    ibaza = 0
    open('Baza_danych.fig');
   end
case 'wejscie'
   if iwej == 0
    set(gcbo,'LineWidth',3 - get(gcbo,'LineWidth'));
   iwej = 1
   else
    iwej = 0
    open('Edycja_wejsc.fig');
   end
    %punkt = get(gca,'CurrentPoint');
   %x = punkt(1,1); y = punkt(1,2);
   %line('XData',punkt(1,1),'YData',punkt(1,2),...,
   %   'Marker','o','MarkerFace','k','MarkerSize',6,...,
   %   'EraseMode','Background','ButtonDownFcn','obslugabuttondown punkcik');
case 'wyjscie'
   %delete(gcbo);
   i ='chuj'
end
 setappdata(h.fig,'axes_counter',counter);