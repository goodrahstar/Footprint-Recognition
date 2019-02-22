 function [perc] = template_match( ts, td)
                                    
%Credit
    tc = uint16(zeros(length(ts),1));
    tc(1,1) = 1;
    tc(2:5,1) = 1;
    tc(6:9,1) = 1;
    tc(10:21,1) = 1;
    tc(21:length(ts),1) = 1;
    
    
    dif = ts - td;
    for i = 1 : length(dif)
        if(dif(i,1) < 0)
            dif(i,1) = dif(i,1) * (-1);
        end
        if(dif(i,2) < 0)
            dif(i,2) = dif(i,2) * (-1);
        end
    end

    dif(:,1) = ((dif(:,1)*100) ./  ts(:,1));
    dif(:,2) = ((dif(:,2)*100) ./  ts(:,2));
     tot = sum(dif(:,1) .* tc(:,1))/sum(tc(:,1));
     tot2 = sum(dif(:,2) .* tc(:,1))/sum(tc(:,1));

    perc = (tot + tot2)/2;
 end