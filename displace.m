function out = displace(x1, y1, x2, y2)
% DISPLACE calculates displacement between two coordinates
% Input Parameter
%       x1, y1      Coordinates of First Point
%       x2, y2      Coordinates of Second Point
%
% Output Parameter
%       out         Displacement between two points
    out = (((x2-x1)^2)+((y2-y1)^2))^0.5;
end