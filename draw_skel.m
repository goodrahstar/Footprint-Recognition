function [] = draw_skel(foot)
% DRAW_SKEL plots different length on image of foot
%
% Input Parameter
%       foot        Left/Right structure of foot

   imshow(foot.img);
   hold on;
   for i = 1 : length(foot.P)
    plot([foot.P_l(i) foot.P(i,1) foot.P_r(i)], [foot.P(i,2) foot.P(i,2) foot.P(i,2)],'-wo','LineWidth',2, 'MarkerEdgeColor','w','MarkerFaceColor',[.49 .50 .63],  'MarkerSize',5);
   end
   
   plot(foot.valley(:,1),foot.valley(:,2),'o', 'MarkerEdgeColor','r','MarkerFaceColor',[.49 1 .63],  'MarkerSize',5);
   
   plot([foot.a_x foot.h_x],[foot.a_y foot.h_y],'-o');
   plot( foot.e_x , foot.e_y ,'o');
   for i = 1 : 4
        plot([foot.e_x foot.valley(i,1)],[foot.e_y foot.valley(i,2)],'-o','MarkerEdgeColor','r','MarkerFaceColor',[.49 1 .63],  'MarkerSize',5)
   end
   if(foot.id == 1)
        for i = 1 : 3
            plot([foot.valley(i,1) foot.finger_tip(i,1)],[foot.valley(i,2) foot.finger_tip(i,2)],'-o')
        end
        plot([foot.valley(4,1) foot.finger_tip(5,1)],[foot.valley(4,2) foot.finger_tip(5,2)],'-o')
   else
       for i = 3 : 5
            plot([foot.valley(i-1,1) foot.finger_tip(i,1)],[foot.valley(i-1,2) foot.finger_tip(i,2)],'-o')
       end
       plot([foot.valley(1,1) foot.finger_tip(1,1)],[foot.valley(1,2) foot.finger_tip(1,2)],'-o')
   end
   hold off;
end