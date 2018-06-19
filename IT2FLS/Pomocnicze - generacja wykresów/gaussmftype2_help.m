x = 0:0.1:10;
[dolna, gorna]=gaussmftype2(x,[1 4 2 6]);
figure;
[X,Y,Col] = plotmf2(x,dolna,gorna);
Col = [0.8 0.9 0.9];
patch(X,Y,Col,'LineWidth',3);
hold on;      
line([4 4],[0 1],'color','g','linewidth',2,'linestyle','--')
text('Position',[4.1,0.1],'String','m_1','fontsize',18) 
line([6 6],[0 1],'color','g','linewidth',2,'linestyle','--')
text('Position',[5.4,0.1],'String','m_2','fontsize',18)
line([4-1 4],[0.6 0.6],'color','b','linewidth',2,'linestyle','--')
text('Position',[3.5,0.65],'String','\sigma_1','fontsize',18)
line([6 6+2],[0.6 0.6],'color','b','linewidth',2,'linestyle','--')
text('Position',[6.5,0.65],'String','\sigma_2','fontsize',18)
xlabel('x','FontSize',18); ylabel('\mu(x)','FontSize',18); grid on
title('\mu(x) = gaussmftype2(x,[\sigma_1 m_1 \sigma_2 m_2])','FontSize',18)
