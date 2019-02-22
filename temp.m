init_db
% 1 0.80  img3
% 2 0.86
for i = 1 : 10
        imname = sprintf('%s%s/Foot/%i.jpg',ROOT,Name{i},1);
        disp(imname);
        img = imread(imname);
        com_temp{i,1} = main(img);
end

for i = 1 : 21
    disp(Name{i});
    t = zeros(1,10);
    for j = 1 : 5
        if(i==17)
            continue;
        end
        imname = sprintf('%s%s/Foot/%i.jpg',ROOT,Name{i},j);
        disp(imname);
        img = imread(imname);
        com_temp{i,j} = main(img);
        for k = 1 : 10
            perc = template_match(com_temp{k,1},com_temp{i,j});
            if(perc < 2)
                t(k) = t(k) + 1;
            end
        end
    end
    disp(t);
    clear t;
    save('com2.mat','com_temp');
end