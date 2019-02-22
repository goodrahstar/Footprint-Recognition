function [ left ] = find_abcd(left)
% FIND_ABCD finds 12 different width of foot above base point at equal
%       interval.
%       left = find_abcd(left) finds width of foot at different point above
%       base point at equal interval and returns the structure of foot
%
% Input Parameter
%       left    Structure of left/right foot.
%
% Output Parameter
%       left    Structure of left/right foot with modification

%% Identify left or right foot and subsequently identify finger next to toe
    if(left.id == 1)
        top_finger = 4;
    else
        top_finger = 2;
    end
    
    a_x = left.a_x;
    a_y = left.a_y;
    h_x = left.finger_tip(top_finger,1);
    h_y = left.finger_tip(top_finger,2);
    
%% Centroid
    e_x = h_x + ((a_x - h_x)/2);
    e_y = h_y + ((a_y - h_y)/2);

%% Identify 12 different height from the base and stores in P
   
    P = double(zeros(12,2));
    len_x = h_x - a_x;
    len_y = h_y - a_y;
    d_len_x = len_x / (length(P) + 5);
    d_len_y = len_y / (length(P) + 5);
    for i = 1 : length(P)
        P(i,1) = a_x + (i * d_len_x);
        P(i,2) = a_y + (i * d_len_y);
    end
%% Identify the end points of width at different heights
    lfm = im2bw(left.img,0.25);
    P_l = zeros(1,length(P));
    P_r = zeros(1,length(P));
    for i = 1 : length(P)
        [P_l(i), P_r(i)] = algo4(lfm,P(i,2));
    end
    
%% Assign each value in structure and modify it.
    left.a_x = a_x;
    left.h_x = h_x;
    left.P = P;
    left.P_l = P_l;
    left.P_r = P_r;
    left.a_y = a_y;
    left.h_y = h_y;
    left.e_x = e_x;
    left.e_y = e_y;
    
end

function [b_l, b_r] = algo4(lfm, b_y)
% Algo4 is used for finding the end points of width at specific height
    [~, col] = size(lfm);
    b_l = 1;
    b_r = col;
    for i = 1 : col
        if(lfm(round(b_y),i)==1)
            b_l = i;
            break;
        end
    end
    for i = col : -1 : i
        if(lfm(round(b_y),i)==1)
            b_r = i;
            break;
        end
    end
end