init_db 

%%
k = 0;
for threshold = 1 : 0.2 : 5
    k= k+1;
for x = 1 : 21
    for y = 1 : 5
        if(x == 17)
            continue
        end
        in_temp = com_temp{x,y};
        res = zeros(21,5);
%         threshold = 3.0;
        t_count = 0;
        for j = 1 : 21
            count = 0;
            if(x == j)
                continue;
            end
            if(j==17)
                continue;
            end
            for i = 1 : 5
                 perc = template_match(com_temp{j,i},in_temp);
                 res(j,i) = perc;
                 if(perc < threshold)
                     count = count + 1;
                     t_count = t_count + 1;
                 end
            end
            out = sprintf('%i : %i accepted out of 5.',j,count);
%             disp(out);
        end
        FAR(((x-1)*5 + y)) = t_count / 95 ; 
    end
end
far_thresh(k,1) = threshold;
far_thresh(k,2) = mean(FAR);
end
plot(far_thresh(:,1),far_thresh(:,2));