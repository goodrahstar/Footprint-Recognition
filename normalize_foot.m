function [foot] = normalize_foot(foot)
% NORMALIZE_FOOT Corrects the orientation of both of foot
%       foot = normalize_foot(foot) takes structure of left/right foot and
%       rotate image accordingly to correct its orientation such that toe
%       points vertically upward
% 
% Input Parameter :
%       foot        foot structure of one of left or right foot having
%                   following members
%                             img   filtered image
%                             aimg  unfiltered image
%                             id    store info of left/right foot
%
% Output Parameter :
%       foot        foot structure as input parameter with aditional
%                   modification

%%  Finding Toe Point
    tmp2 = top_histo(im2bw(foot.img,graythresh(foot.img)));
    [row, col, ~] = size(foot.img);
    for i = 1 : length(tmp2)
        if(tmp2(i)==0)
            tmp2(i) = row;
        end
    end
    tmp_z = smooth(tmp2);
    for i = 1 : 40
        tmp_z = smooth(tmp_z);
    end
    k = 2;
    loc_max.x(1) = 1;
    loc_max.y(1) = tmp_z(1);
    for i = 2 : length(tmp_z) - 1
        if(tmp_z(i - 1) <= tmp_z(i) && tmp_z(i + 1) <= tmp_z(i) && tmp_z(i) < row/2)
              loc_max.x(k) = i;
              loc_max.y(k) = tmp_z(i);
               k = k + 1;
        end
    end
%     figure;           %% Debug Point
%     plot(tmp_z);
%     figure;
    loc_max.x(k) = length(tmp_z);
    loc_max.y(k) = tmp_z(length(tmp_z));
    k = 1;
    for i = 1 : length(loc_max.x) - 1
        [fing_y(k) fing_x(k)] = min(tmp_z(loc_max.x(i):(loc_max.x(i + 1))));
        fing_x(k) = fing_x(k) + loc_max.x(i);
        k = k + 1;
    end
    
%% Calculating finger coordinate next to toe
    if(foot.id == 1)
        h_y = fing_y(length(fing_y) - 1);
        h_x = fing_x(length(fing_y) - 1);
    else
        h_y = fing_y(2);
        h_x = fing_x(2);
    end
    
%% Finding coordinate of base point of foot.
     [foot.a_x, foot.a_y] = base_point(foot.img);
     p = foot.a_y - h_y;
     b = foot.a_x - h_x;
     c_y = round(h_y + round(p/2));
     c_x = round(h_x + round(b/2));
%      foot.aimg(c_y - 50 : c_y + 50, c_x - 50 : c_x + 50,1 : 2) = 1;
%      imshow(foot.aimg);
%      hold on;
%      plot(c_x,c_y,'o');
%      plot(h_x,h_y,'o');
%      plot([h_x foot.a_x],[h_y foot.a_y],'-o');
%      plot(fing_x,fing_y,'o');
%      figure;
    [row, col, ~] = size(foot.aimg);
    t_img = uint8(zeros(size(foot.aimg)));
    ac_x = round(col/2);
    ac_y = round(row/2);
%%   Shifting Center of Foot to the center of image;
    if(c_x < ac_x)
        d_x = ac_x - c_x;
        t_img(:,d_x + 1 : col,:) = foot.aimg(:,1:(col-d_x),:);
    else
        d_x = c_x - ac_x;
        t_img(:,1 : col - d_x ,:) = foot.aimg(:,d_x + 1 : col,:);
    end
    c_img = uint8(zeros(size(foot.aimg)));
    if(c_y < ac_y)
        d_y = ac_y - c_y;
        c_img(d_y + 1 : row,:,:) = t_img(1:(row-d_y),:,:);
    else
        d_y = c_y - ac_y;
        
        c_img(1 : row - d_y,:,:) = t_img(d_y + 1 : row,:,:);
    end
    t_img = c_img;
%      imshow(t_img);
%      hold on;
%         plot(col/2,row/2,'o', 'MarkerEdgeColor','r','MarkerFaceColor',[.49 1 .63],  'MarkerSize',15);
%      plot([foot.a_x,c_x, h_x],[foot.a_y,c_y, h_y],'-yo');
%      plot(col/2,row/2,'o', 'MarkerEdgeColor','r','MarkerFaceColor',[.49 1 .63],  'MarkerSize',5);

%%  Rotating image to correct Orientation
rad = atan(b/p);
      deg = (rad * 180)/pi;
%       imshow(t_img);figure;
      r_img = imrotate(t_img,-deg);
%       imshow(r_img);
      clear foot.aimg foot.aimg;
      foot.aimg = r_img;
      foot.img = generate_mask(foot.aimg);
%      figure;
%      imshow(foot.img);
 end