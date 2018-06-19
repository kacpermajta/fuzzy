x = 0:0.1:10;
[dolna, gorna] = trimftype2(x,[1 4 6 3 7 8 ]);
figure;
[X,Y,Col] = plotmf2(x,dolna,gorna);
Col = [0.8 0.9 0.9];
patch(X,Y,Col,'LineWidth',3);
hold on;
line([1 1],[0 1],'color','g','linewidth',2,'linestyle','--')
text('Position',[1.1,0.2],'String','a_1','fontsize',18) 
line([4 4],[0 1],'color','g','linewidth',2,'linestyle','--')
text('Position',[6.1,0.2],'String','b_1','fontsize',18)
line([6 6],[0 1],'color','g','linewidth',2,'linestyle','--')
text('Position',[4.1,0.2],'String','c_1','fontsize',18)
line([3 3],[0 1],'color','g','linewidth',2,'linestyle','--')
text('Position',[3.1,0.2],'String','a_2','fontsize',18) 
line([8 8],[0 1],'color','g','linewidth',2,'linestyle','--')
text('Position',[8.1,0.2],'String','b_2','fontsize',18)
line([7 7],[0 1],'color','g','linewidth',2,'linestyle','--')
text('Position',[7.1,0.2],'String','c_2','fontsize',18)
xlabel('x','FontSize',18); ylabel('\mu(x)','FontSize',18); grid on
title('\mu(x) = trimftype2(x,[a_1 c_1 b_1 a_2 c_2 b_2])','FontSize',18)