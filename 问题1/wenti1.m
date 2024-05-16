clc;clear
url = 'D:\Desktop\附件2 慢性病及相关因素流调数据.xlsx';
text = xlsread(url);
[row,col] = size(text);
panduan = zeros(row,1);
%15 33 197
text = [text(:,1:14) panduan text(:,15:col)];
text = [text(:,1:32) panduan text(:,33:col+1)];
text = [text(:,1:196) panduan text(:,197:col+2)];
%数据预处理
[row,col] = size(text);
%方便数据处理,将所有的NAN值转换为0
text(find(isnan(text)==1)) = 0;
for i=1:row
    %处理异常值
    %吸烟
    if text(i,9) == 3
        if text(i,10) > 0 || text(i,11) > 0 || text(i,12) > 0
            text(i,15) = -1;
        end
    end
    %饮酒
    if text(i,16) == 2
        if sum(text(i,17:32)) > 0
            text(i,33) = -1;
        end
    end
    %处理缺失值
    %吸烟
    if text(i,9) == 0
        if text(i,10) > 0 || text(i,11) > 0 || text(i,12) > 0
            text(i,1) = 1;
        else
            text(i,1) = 3;
        end
    end
    if text(i,16) == 0
        if sum(text(i,17:32)) > 0
            text(i,1) = 1;
        else
            text(i,1) = 2;
        end
    end
end
%饮食
%是否吃 天/次 周/次 月/次 平均每次的摄入量
[row,col] = size(text);
for i=1:row
    for j = 55:5:197-8
        %处理错误值
        if text(i,j) == 1
            if text(i,j+1)+text(i,j+2)+text(i,j+3) == 0 || text(i,j+4) == 0
                text(i,197) = -1;
                break;
            end
        end
        %处理缺失值
        if text(i,j) == 0
            %存在摄入频率即为1
            if text(i,j+1)+text(i,j+2)+text(i,j+3)> 0
                text(i,j) = 1;
            else
                text(i,j) = 2;
            end
        end
    end
end
%去除掉无法计算家庭人数的数据
for i = 1:row
    if text(i,39)+text(i,40)+text(i,46)+text(i,47)+text(i,53)+text(i,54) == 0
        text(i,197) = -1;
    end
end
%去除年龄不合理的和年龄偏大的,其他指标不合理的
for i = 1:row
    if text(i,2) <=1943 || text(i,225) <=130 || text(i,226)<=35 || text(i,226)>=140
       text(i,197) = -1;
    end
    if find(text(i,227:col) == 0)
        text(i,197) = -1;
    end
end

t = 1;
for i = 1:1:row
     if(text(i,15) > -1 && text(i,33) > -1 && text(i,197) > -1)
         new1(t,:) = text(i,:); 
         t = t + 1;
     end
end
%获得预处理后的数据new1 进行处理
[row,col] = size(new1);
%1.将所有指标的数据进行正向化
%指标1:每天摄入12种以上食物计数
zhibiao1 = zeros(row,1);
for i=1:row%从第一个到最后一个居民
    count = 0;
    for j = 55:5:197-8
        if new1(i,j+1) ~= 0
            %判断天数
            count= count+1;
        elseif new1(i,j+2) >= 7
            %平均每天吃一次
            count=count+1;
        elseif new1(i,j+3)>=28
            %一个月看做是28天,平均每天一次
            count=count+1;
        end
    end
    for j=190:196
        if new1(i,j) > 0
            count=count+1;
        end
    end    
    zhibiao1(i,1) = count;
end
%指标2 每周摄入25种以上
zhibiao2 = zeros(row,1);
for i=1:row%从第一个到最后一个居民
    count = 0;
    for j = 55:5:197-8
        if new1(i,j+1) ~= 0
            %判断天数
            count= count+1;
        elseif new1(i,j+2) ~= 0
            %每周都吃
            count=count+1;
        elseif new1(i,j+3)>=4
            %一个月看做是28天,至少平均每周一次
            count=count+1;
        end
    end
    for j=190:196
        if new1(i,j) > 0
            count=count+1;
        end
    end    
    zhibiao2(i,1) = count;
end
%指标三 保证每天摄入不少于300g的新鲜蔬菜
zhibiao3 = meitianyinshi(145,row,new1,50);
%指标4 保证每天摄入200~350g的新鲜水果，果汁不能代替鲜果  
zhibiao4 = meitianyinshi(175,row,new1,50);
%指标5 吃各种各样的奶制品，与第四版相比最高摄入量由原来的300g提高到500g
%奶粉 鲜奶 酸奶
zhibiao5 = meitianyinshi(105,row,new1,50)+meitianyinshi(110,row,new1,10)+meitianyinshi(115,row,new1,50);
%指标6:鱼禽、蛋类和瘦肉摄入要适量，平均每天120~200g
%80 
zhibiao6 = meitianyinshi(80,row,new1,50)+meitianyinshi(85,row,new1,50)+meitianyinshi(90,row,new1,50)
           +meitianyinshi(100,row,new1,50)+meitianyinshi(120,row,new1,50)
%指标7:成人每天摄入烹调油25~30g
%将三餐就餐的平均人数四舍五入作为其家庭成员人数
zhibiao7 = jiatingyinshipanduan(190,row,new1,500)+jiatingyinshipanduan(191,row,new1,500);
% zhibiao7 = (植物油和动物油)
%指标8:食用盐＜5g
zhibiao8 = jiatingyinshipanduan(192,row,new1,50);
%1.对各项指标进行正向化处理
%指标3、4、6、7属于区间型
zhibiao3 = Inter2Max(zhibiao3,300,500);
zhibiao4 = Inter2Max(zhibiao4,200,350);
zhibiao5 = Inter2Max(zhibiao5,300,500);
zhibiao6 = Inter2Max(zhibiao6,120,200);
zhibiao7 = Inter2Max(zhibiao7,25,30);
%指标1 2当做极大型处理
%指标8特殊处理
zhibiao8 = teshuchuli(zhibiao8,5);
%2.归一化处理
zhibiao = [zhibiao1 zhibiao2 zhibiao3 zhibiao4 zhibiao5 zhibiao6 zhibiao7 zhibiao8];
zhibiao = zhibiao ./ repmat(sum(zhibiao.*zhibiao) .^ 0.5, row, 1);
%3.利用熵权法计算各项指标的权重
W = Entropy_Method(zhibiao);
%4.计算最终得分
zuidajuli = sum([(zhibiao - repmat(max(zhibiao),row,1)) .^ 2 ] .* repmat(W,row,1) ,2) .^ 0.5;   % D+ 与最大值的距离向量
zuixiaojuli = sum([(zhibiao - repmat(min(zhibiao),row,1)) .^ 2 ] .* repmat(W,row,1) ,2) .^ 0.5;   % D- 与最小值的距离向量
score = zuixiaojuli ./ (zuidajuli+zuixiaojuli);    % 未归一化的得分
%5.将分数按照从高到低的顺序进行排序
%[score,index] = sort(score,'descend')
%去除加入的辅助行
new1 = [new1(:,1:14)  new1(:,16:32) new1(:,34:196) new1(:,198:col)];