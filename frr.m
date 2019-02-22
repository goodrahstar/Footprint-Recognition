init_db 
load('Df_mat/com_temp.mat');
%%
k = 0;
for threshold = 1 : 0.2 : 5
    k= k+1;
for x = 1 : 21
    for y = 1 : 5
        if(x == 17)
            continue
        end
        t_count = 0;
        in_temp = com_temp{x,y};
%         threshold = 3.0;
        for i = 1 : 5
                if(y == i)
                    continue;
                end
                 perc = template_match(in_temp,com_temp{x,i});
                 if(perc > threshold)
                     t_count = t_count + 1;
                 end
        end
        FRR(((x-1)*5 + y)) = t_count / 4 ; 
    end
end
frr_thresh(k,1) = threshold;
frr_thresh(k,2) = mean(FRR);
end
plot(frr_thresh(:,1),frr_thresh(:,2));