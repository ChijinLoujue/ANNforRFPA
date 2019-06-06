# ANNforRFPA
## 引言

本科毕业设计《基于人工神经网络的射频功放的非线性模型的构建》中的一部分代码，非全部代码，但具有代表性。具体内容见本人CSDN博客：<https://blog.csdn.net/ChijinLoujue/article/details/86564616>

## 说明
### 命名方式：
​                程序：算法_参数类型_功放型号_版本.m
​                数据：参数_功放型号_版本.txt
### 注：
​                AMAM代表着输入和输出包络的幅度，PMPM代表输入和输出相位；
​                BP,RBF,Elman,分别代表几种算法；
​                以下代码都为最终版本

## 目录：

BP_AP_9040_1.m                  
Elman_AP_9040_1.m             
netBPAP9040_1.mat             //保存的训练后参数确定的神经网络
NRMS.m                              //误差计算函数
PMPM9040_1.txt                      
RBF_AP_9040_1.m                
Rd_Nu.mat                          //保存的随机初始权值
Rd_Num.m                          //随机初始权值生成函数  
RMSE.m                              //误差计算函数
README.md  
AMAM9040_1.txt     //输入输出包络幅度数据
PMPM9040_1.txt     //输入输出包络相位数据