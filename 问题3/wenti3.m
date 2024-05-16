clear;clc
%导入饮酒数据新型处理
% data_title = ["是否饮酒","饮酒年数","高度每周白酒饮用量","低度每周白酒饮用量","啤酒每周饮用量","黄酒、糯米酒每周饮用量","葡萄每周酒引用量"];
data_title = ["是否饮酒","饮酒年数","每周饮酒量"]
url = 'D:\Desktop\饮酒.xlsx';
data = xlsread(url);
[row,col] = size(data);
Drinking = zeros(row,1);
for i=1:row
    count = 1;
    sum = 0;
    if data(i,2) == 99
        data(i,2) = mean(data(:,2));
    end
    for j=4:3:col
        sum = sum + data(i,j)*data(i,j+1)*50;
        count=count+1;
    end
    Drinking(i) = sum;
end
a = [data(:,1) data(:,2) Drinking];
xlswrite('D:\Desktop\饮酒处理后数据.xlsx',[data_title;[data(:,1) data(:,2) Drinking]])
clear;clc
[row,col] = size(data);
score = zeros(row,1);
for i = 1:row
    if data(i,1) == 1
        score(i) = 0;
    elseif data(i,1) == 2
        score(i) = 1.5*data(i,2);
    elseif data(i,1) ==3
        score(i) = 4*data(i,2);
    elseif data(i,1) == 4
        score(i) = 6*data(i,2);
    end
end
        
        