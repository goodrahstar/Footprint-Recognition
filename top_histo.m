function [out] = top_histo( img )
    [row col depth] = size(img);
    if(depth > 3)
          out = 0;
          display('Input image must be bw');
          return;
    end
    out = zeros(1, col);
    
    for i = 1 : col
        for j = 1 : row
                if(img(j,i)==1)
                      out(1, i) = j;
                      break;
                end
        end
    end
end