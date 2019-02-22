            c_r = cat(2,center,radius,k)
            for i = 1 : z
                clear r
                [r, ~] = find(k==i)
                clear avg;
                if(length(r)==1)
                    avg = c_r(r,:);
                else
                    avg = mean(c_r(r,:));
                end
                for j = 1 : length(r)
                    center(r(j),:) = avg(:,1:2)
                    radius(r(j)) = avg(:,3);
                end
            end