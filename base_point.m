function [base_x, base_y] = base_point(imask)
% BASE_POINT finds the base point of lower most curve of foot
% [base_x, base_y] = base_point(imask) returns the x and y coordinates of
%       lower most point of lower curve of foot.
%
% Input Parameter :
%       imask       Truecolor image of m-by-n-by-3 of one of right or left
%                   foot.
%
% Output Parameter :
%       base_x      x coordinate
%       base_y      y coordinate
        mask = im2bw(imask,0.30);
        tmp2 = bottom_histo(mask);
        tmp_z = smooth(tmp2);
        for i = 1 : 40
            tmp_z = smooth(tmp_z);
        end
        [base_y, base_x] = max(tmp_z);
end