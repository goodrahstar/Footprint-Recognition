function [template] = main(img)
%       MAIN Extracts statistical feature of Foot.
%       T = main(img) processes Truecolor m-by-n-by-3 image of foot and
%       generates 22-by-2 template extracting statistical feature of both 
%       pair of Foot.
% 
%       Input Parameter :
%           img         Input Image of Foot
%                       Must be Truecolor Image of dimension m-by-n-by-3
%                       
%       Output Parameter :
%           template 	Output Template of Foot
%                       22-by-2 uint16 Matrix representing statistical
%                       feature of both Foot.

    foot = separate_foot(img);
%%  Processing Left Foot    
%   Correct Foots Orientation & Remove Noise   
    foot.left = normalize_foot(foot.left); 
%   Find Base of Foot
    [foot.left.a_x, foot.left.a_y] = base_point(foot.left.img); 
%   Find Finger Tips of Foot    
    [foot.left.center, foot.left.radius, foot.left.finger_tip] = five_finger(foot.left.img); % Find All Finger Tips
%   No further processing if unable to find finger tips    
    if(isempty(foot.left.center))
        disp('Unable To Find Finger Tips. Terminating');
        template = [];
        return;
    end
    
%   Find 6 different points on Foot for statistical info of foots width.
    foot.left = find_abcd(foot.left);
    
%   Find Valley Between Fingers of Foot
    foot.left.valley = find_valley(foot.left, foot.left.img);
    
%   Generates template for Left Foot
     temp = generate_template(foot.left);
     foot.template(:,1) = temp(:,1);
    
    
%%  Processing Right Foot in similar fashion as above
    foot.right = normalize_foot(foot.right); % Correct Foots Orientation & Remove Noise
    [foot.right.a_x, foot.right.a_y] = base_point(foot.right.img); % Find Base of Foot
    [foot.right.center, foot.right.radius, foot.right.finger_tip] = five_finger(foot.right.img); % Find All Finger Tips

    if(isempty(foot.right.center))  % No further processing if unable to find finger tips
        disp('Unable To Find Finger Tips. Terminating');
        foot.template(:,2) = [];
        template = uint16(foot.template);
        return;
    end
    
    foot.right = find_abcd(foot.right);
    % Find Valley Between Fingers of Foot
    foot.right.valley = find_valley(foot.right, foot.right.img);
    
    % Generating Template of Right Foot
     temp = generate_template(foot.right);
     foot.template(:,2) = temp(:,1);
    
     template = uint16(foot.template);
     
%% Draw Skeleton is a optional part for debugging
       figure;
       subplot(1,2,1);
       draw_skel(foot.left);
       subplot(1,2,2);
       draw_skel(foot.right);
end
    