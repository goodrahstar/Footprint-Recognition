function [template] = generate_template(foot)
% GENERATE_TEMPLATE Creates template of particular foot
%      template = generate_template(foot) calculates the specific length
%      between coordinates and returns an array of 24-by-1 uint16
% Input Parameter
%       foot        Left/Right foot structure
%
% Output Parameter
%       template    24-by-1 uint16 array

    template =  (zeros(24,1));
    template(1,1) = displace(foot.h_x,foot.h_y,foot.a_x,foot.a_y);
    if(foot.id == 1)
        for i = 1 : 3
            template(1+i,1) = displace(foot.valley(i,1),foot.valley(i,2),foot.finger_tip(i,1),foot.finger_tip(i,2));
        end
        template(5,1) = displace(foot.valley(4,1), foot.valley(4,2), foot.finger_tip(5,1), foot.finger_tip(5,2));
    else
        template(2,1) = displace(foot.valley(1,1), foot.valley(1,2), foot.finger_tip(1,1), foot.finger_tip(1,2));
        for i = 3 : 5
            template(i,1) = displace(foot.valley(i-1,1), foot.valley(i-1,2), foot.finger_tip(i,1), foot.finger_tip(i,2));
        end
    end
    
    for i = 1 : 4
        template(i+5,1) = displace(foot.e_x, foot.e_y, foot.valley(i,1), foot.valley(i,2));
    end
    
    for i = 1 : length(foot.P)
        template(9 + i,1) = foot.P_r(i) - foot.P_l(i);
    end
    t = 9 + length(foot.P);
    for i = 1 : 3
        template(t + i,1) = displace(foot.valley(i,1),foot.valley(i,2),foot.valley(i+1,1),foot.valley(i+1,2));
    end
end

%
% template
%         1       Foot Length             4
%         2-5       Finger Length           2
%         6-9       Valley Length           
%         10-21   Foot Width           
%         22-24      Inter-Valley Length     
