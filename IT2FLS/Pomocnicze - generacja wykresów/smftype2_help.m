x = 0:0.01:10;
[dolna, gorna] = smftype2(x,[2 5 1 3]);
figure;
[X,Y,Col] = plotmf2(x,dolna,gorna);
Col = [0.8 0.9 0.9];
patch(X,Y,Col,'LineWidth',3);
hold on;
line([3 3],[0 1],'color','g','linewidth',2,'linestyle','--')
text('Position',[3.1,0.1],'String','c_1','fontsize',18) 
line([5 5],[0 1],'color','g','linewidth',2,'linestyle','--')
text('Position',[5.1,0.1],'String','c_2','fontsize',18)
xlabel('x','FontSize',18); ylabel('\mu(x)','FontSize',18); grid on
title('\mu(x) = smftype2(x,[a_1 c_1 a_2 c_2])','FontSize',18)