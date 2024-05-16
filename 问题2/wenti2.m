clear;clc
url = 'D:\Desktop\附件2 慢性病及相关因素流调数据.xlsx';
text = xlsread(url,2);
%对生活习惯数据进行评分
%1.对数据进行正向化
%其中1 3 5为极小型，2 4 6为极大型
[row,col] = size(text);
for i=1:2:col
    text(:,i) = Min2Max(text(:,i));
end
%2.归一化处理
text = text ./ repmat(sum(text.*text) .^ 0.5, row, 1);  
%3.利用熵权法计算各项指标的权重
W = Entropy_Method(text);
%4.计算最终得分
zuidajuli = sum([(text - repmat(max(text),row,1)) .^ 2 ] .* repmat(W,row,1) ,2) .^ 0.5;   % D+ 与最大值的距离向量
zuixiaojuli = sum([(text - repmat(min(text),row,1)) .^ 2 ] .* repmat(W,row,1) ,2) .^ 0.5;   % D- 与最小值的距离向量
score = zuixiaojuli ./ (zuidajuli+zuixiaojuli);
%对数据进行斯皮尔曼相关系数
%将得出的数据保存到excel表格中并读取数据
text = xlsread(url,4);
text(:,1) = data_conversion(text(:,1));
text(:,2) = data_conversion(text(:,2));
[R,P]=corr(text, 'type' , 'Spearman');
%显著性水平判断
a = P < 0.01  % 标记3颗星的位置
b = (P < 0.05) .* (P > 0.01)  % 标记2颗星的位置
c = (P < 0.1) .* (P > 0.05) % % 标记1颗星的位置
