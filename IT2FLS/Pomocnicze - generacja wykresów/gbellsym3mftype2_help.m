x = 0:0.1:10;
[dolna, gorna]=gbellsym3mftype2(x,[1 1 2 5]);
figure;
[X,Y,Col] = plotmf2(x,dolna,gorna);
Col = [0.8 0.9 0.9];
patch(X,Y,Col,'LineWidth',3);
hold on;
line([5 5],[0 1],'color','g','linewidth',2,'linestyle','--')
text('Position',[5.1,0.1],'String','c','fontsize',18) 
line([5-1 5],[0.5 0.5],'color','b','linewidth',2,'linestyle','--')
text('Position',[4.4,0.55],'String','a','fontsize',18)
line([3 4],[0.5 0.5],'color','r','linewidth',2,'linestyle','--')
text('Position',[3.4,0.55],'String','d','fontsize',18)
xlabel('x','FontSize',18); ylabel('\mu(x)','FontSize',18); grid on
title('\mu(x) = gbellsym3mftype2(x,[a d b c])','FontSize',18)