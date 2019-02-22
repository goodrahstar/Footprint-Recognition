function [valley] = find_valley(left , img)
% FIND_VALLEY Identifies valley point between two fingers
%   valley = find_valley(left,img) identifies valley points between two
%   finger and returns an array of coordinates of each valley.
% Input Parameter
%   left        left/right foot structure
%   img         left/right foot image
%
% Output Parameter
%   valley      4-by-2 array of x and y coordinates of each valley point


%% Generate mask of foot image 
    lfm = im2bw(img,0.30);

%% Connecting top of fingers
%  in order to preserve black pixel distribution between two consecutive
%  finger
    finger_tip = left.finger_tip;
    for i = 1 : 4
        if(finger_tip(i,2) > finger_tip(i+1,2))
            lfm(round(finger_tip(i,2))-10:round(finger_tip(i,2))+20,round(finger_tip(i,1)):round(finger_tip(i+1,1))) = 1;
        else
            lfm(round(finger_tip(i+1,2))-10:round(finger_tip(i+1,2))+20,round(finger_tip(i,1)):round(finger_tip(i+1,1))) = 1;
        end
    end
    
%% Removing background black pixel around foot using imfill()

    [row, col] = size(lfm);
    lfm = cat(2,(false(row,1)),lfm,(false(row,1)));
    lfm = cat(1,false(1,col+2),lfm,false(1,col+2));
    lfm = imfill(lfm,[1 1],4);
    [row, col] = size(lfm);
    
%% Removing Texture of foot if it generated while generation of mask

    if(left.id == 1)
        top_finger = 4;
    else
        top_finger = 2;
    end
    a_y = left.a_y;
    h_y = left.finger_tip(top_finger,2);
    
    e_y = h_y + ((a_y - h_y)/2);
    g_y = e_y + ((h_y - e_y)/2);
    f_y = e_y + ((g_y - e_y)/2);
    
    lfm(round(f_y):row,:) = 1;
    
%% Finding the black first pixel hit from the bottom of image

    tmp_z = zeros(1, col);
    for i = 1 : col
        for j = row : -1 : 1
                if(lfm(j,i)==0)
                      tmp_z(1, i) = j;
                      break;
                end
        end
    end

%% Identifing Valley Points using black pixel hit value

    valley = zeros(4,2);
   
    for i = 1 : 4
        [valley(i,2), valley(i,1)] = max(tmp_z(round(finger_tip(i,1)):round(finger_tip(i+1,1))));
        valley(i,1) = valley(i,1) + finger_tip(i,1);
    end
    
%% Assigning predicted valley point in case actual valley hadn't found

    default_valley = zeros(4,2);
    for i = 1 : 4
        default_valley(i,1) = left.finger_tip(i,1) + ((left.a_x -  left.finger_tip(i,1)) * 0.12);
        default_valley(i,2) = left.finger_tip(i,2) + ((left.a_y -  left.finger_tip(i,2)) * 0.12);
    end
    for i = 1 : 4
        if(valley(i,2) < min(left.finger_tip(:,2)) || valley(i,2) > left.e_y)
            valley(i,:) = default_valley(i,:);
        end
         if(valley(i,1) < min(left.finger_tip(:,1)) || valley(i,1) > max(left.finger_tip(:,1)))
             valley(i,:) = default_valley(i,:);
         end
    end
end