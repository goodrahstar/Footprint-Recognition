function [center, radius, finger_tip] = five_finger(img)
%   FIVE_FINGER  finds the coordinates of all five finger tips
%       [center, radius, finger_tip] = five_finger(img) finds the
%       finger_tip of each finger using Circle Hugh Transformation to find
%       circle around the finger tip
%
%   Input Parameter : 
%       img     Truecolor image of m-by-n-by-3 of one of left or right foot
%
%   Output Parameter :
%       center      5-by-2 array of x and y coordinates of five circle around
%                   each finger
%       radius      5-by-1 array of every circle
%       finger_tip  5-by-1 array of x and y coordinates of each finger tip
%


% Finding circular structure in whole image
        sens = 0.80;
        [center, radius] = imfindcircles(img,[100 150],'Method','TwoStage','EdgeThreshold',0.1,'Sensitivity',sens);

        if(isempty(center)) % No further Processing
            return;
        end
        while(~unique_five(center,radius))
            sens = sens + 0.005;
            [center, radius] = imfindcircles(img,[100 120],'Sensitivity',sens,'Method','TwoStage');            
            if(sens > 0.90)
                disp('Unable To Proceed beyond 0.90 Sensitivity : Five_Finger.m');
                center = [];
                return;
            end
        end
% This loop terminates if 5 or more circles found;

% Identify circles around finger
        [center, radius] = find_five(center,radius);
        
% Calculate Finger_Tip coordinates
        finger_tip = center;
        finger_tip(:,2) =  finger_tip(:,2) - radius(:,1);
% %         imshow(img);
% %         viscircles(center , radius ,'EdgeColor','b');
end

function [status] = unique_five(center, radius)
        % Sorting
                c_r = cat(2,center,radius);
                c_r = sortrows(c_r);
                center = c_r(:,1:2);
                radius = c_r(:,3);
        % Verifing with adjacent Circles
            k = 1;
            for i = 1 : length(radius) - 1
                disp = round(displace(center(i,1),center(i,2),center(i+1,1),center(i+1,2)));
                if( disp < (4 * radius(i))/3 )
                    continue;
                else
                    k = k + 1;
                end
            end
        % if k is greater than 5 then unique five exist.
            if( k < 5)
                status = 0;
            else
                status = 1;
            end
end

function [center, radius] = find_five(center, radius)
        % Sorting
                c_r = cat(2,center,radius);
                c_r = sortrows(c_r);
                center = c_r(:,1:2);
                radius = c_r(:,3);
        % Ranking Unique Circle
            k = zeros(length(radius),1);
            z = 1;
            for i = 1 : length(radius) - 1
                disp = round(displace(center(i,1),center(i,2),center(i+1,1),center(i+1,2)));
                if( disp < ((4 * radius(i))/3) )
                    k(i,1) = z;
                else
                    k(i,1) = z;
                    z = z + 1;
                end
            end
            k(length(radius),1) = z;
        % Averaging
            c_r = cat(2,center,radius,k);
            for i = 1 : z
                clear r
                [r, ~] = find(k==i);
                clear avg;
                if(length(r)==1)
                    avg = c_r(r,:);
                else
                    avg = mean(c_r(r,:));
                end
                for j = 1 : length(r)
                    center(r(j),:) = avg(:,1:2);
                    radius(r(j)) = avg(:,3);
                end
            end
        % Selecting Unique Circles
            z = 1;
            for i = 1 : length(radius)
                if(k(i)==z)
                    d(z,:) = center(i,:);
                    r(z,:) = radius(i,:);
                    z = z+1;
                end
            end
            clear center radius
            center = d;
            radius = r;
        % Selecting Top Five Circles
                clear c_r;
                c_r = cat(2,center,radius);
                c_r = sortrows(c_r,2);
        %       size(c_r) Debug Point 2
                center = c_r(1:5,1:2);
                radius = c_r(1:5,3);
        % Last Sorting
                c_r = cat(2,center,radius);
                c_r = sortrows(c_r);
                center = c_r(:,1:2);
                radius = c_r(:,3);
end