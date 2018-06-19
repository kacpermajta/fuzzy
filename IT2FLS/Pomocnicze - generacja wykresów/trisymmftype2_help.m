x = 0:0.1:10;
[dolna, gorna] = trisymmftype2(x,[1 5 3]);
figure;
[X,Y,Col] = plotmf2(x,dolna,gorna);
Col = [0.8 0.9 0.9];
patch(X,Y,Col,'LineWidth',3);
hold on;
line([1 1],[0 1],'color','g','linewidth',2,'linestyle','--')
text('Position',[1.1,0.2],'String','a','fontsize',18) 
line([3 3],[0 1],'color','g','linewidth',2,'linestyle','--')
text('Position',[3.1,0.2],'String','b','fontsize',18)
line([5 5],[0 1],'color','g','linewidth',2,'linestyle','--')
text('Position',[5.1,0.2],'String','c','fontsize',18)
xlabel('x','FontSize',18); ylabel('\mu(x)','FontSize',18); grid on
title('\mu(x) = trisymmftype2(x,[a b c])','FontSize',18)