clear;clc
%读入数据
url = "D:\Desktop\聚类分析.xlsx"
Youth_data = xlsread(url,4);
Middle_aged_data = xlsread(url,6);
Elderly_data = xlsread(url,8);
%对青年数据进行分析,青年存在运动性水平低和生活习惯水平偏低的问题
y_p = size(Youth_data,1);
m_p = size(Middle_aged_data,1);
e_p = size(Elderly_data,1);
%运动型水平
Athletic_level_avg = (sum(Middle_aged_data(:,5))+sum(Elderly_data(:,5)))/(m_p+e_p)
%生活习惯
Lifestyle_habits = (sum(Middle_aged_data(:,6))+sum(Elderly_data(:,6)))/(m_p+e_p)
%判断各种情况人群人数
[level1,level2,level3,level4]=Type_judgment(Youth_data,Athletic_level_avg,Lifestyle_habits,5,6)
%运动型水平和生活习惯水平正常
all_normal = level1/y_p;
%运动型水平低
abnormal1 = level2/y_p;
%生活习惯水平低
abnormal2 = level3/y_p;
%二者均低
all_abnormal = level4/y_p;
y_c = [level1,level2,level3,level4];
y_pp = [all_normal abnormal1 abnormal2 all_abnormal];

%对中年数据进行分析,中年人存在吸烟水平和饮酒水平水平偏高的问题
%饮酒水平
Drinking_level_avg = (sum(sum(Youth_data(:,1:2)))+sum(sum(Elderly_data(:,1:2))))/(y_p+e_p)
%吸烟水平
Smoking_level_avg = (sum(sum(Youth_data(:,3:4)))+sum(sum(Elderly_data(:,3:4))))/(y_p+e_p)
%判断各种情况人群人数
[level1,level2,level3,level4]=Type_judgment1(Middle_aged_data,Drinking_level_avg,Smoking_level_avg,1,2,3,4)
%吸烟和喝酒正常
all_normal = level1/m_p;
%喝酒偏高
abnormal1 = level2/m_p;
%吸烟偏高
abnormal2 = level3/m_p;
%吸烟和喝酒均偏高
allm_abnormal = level4/m_p;
m_c = [level1,level2,level3,level4];
m_pp = [all_normal abnormal1 abnormal2 all_abnormal];
%老年人数据分析,老年人血糖和血压偏
%获取 140 90对应的值
%data = get_data(130,80);
data = 0.80977;
[level1,level2,level3,level4]=Type_judgment2(Elderly_data,data,7,15,12);
all_normal = level1/e_p;
%高血压
abnormal1 = level2/e_p;
%糖尿病
abnormal2 = level3/e_p;
%均患有
allm_abnormal = level4/e_p;
o_c = [level1,level2,level3,level4];
o_pp = [all_normal abnormal1 abnormal2 allm_abnormal];