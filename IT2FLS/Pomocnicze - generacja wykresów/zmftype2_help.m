[dolna, gorna] = zmftype2(x,[3 5 4 7]);
figure;
[X,Y,Col] = plotmf2(x,dolna,gorna);
Col = [0.8 0.9 0.9];
patch(X,Y,Col,'LineWidth',3);
hold on;
line([3 3],[0 1.0],'color','g','linewidth',2,'linestyle','--')
text('Position',[3.1,0.1],'String','l_1','fontsize',18) 
line([5 5],[0 1.0],'color','g','linewidth',2,'linestyle','--')
text('Position',[5.1,0.1],'String','r_1','fontsize',18)
line([4 4],[0 1.0],'color','b','linewidth',2,'linestyle','--')
text('Position',[4.1,0.1],'String','l_2','fontsize',18)
line([7 7],[0 1.0],'color','b','linewidth',2,'linestyle','--')
text('Position',[7.1,0.1],'String','r_2','fontsize',18)
xlabel('x','FontSize',18); ylabel('\mu(x)','FontSize',18); grid on
title('\mu(x) = zmftype2(x,[l_1 r_1 l_2 r_2])','FontSize',18)