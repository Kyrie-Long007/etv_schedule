clc;
clear;
% 假设A的初始位置为0，B的初始位置为31
A=[0 10	11	24	29	2	2	13	30	6	9	6	25	3	3	20 23	14	6	3	1	11	28	6	9	1	11	9	13	4	9 0];%case study小车A轨迹数据
B=[ 31  25	27	22	20	17	24	27	20	18	3	30	19	20	1	30 28	17	24	27	23	17	15	13	12	30	24	10	18	24	23 31];%case study小车B轨迹数据
%A=[0,2,11,28,30,3,4,9,20,6,10,24,25,1,3,1,3,11,23,11,29,6,9,9,13,2,13,9,6,14,6,0];%case study niniload小车A轨迹数据
%B=[31,24,23,30,30,10,1,15,12,19,20,20,18,20,25,24,24,18,22,17,23,17,24,13,25,27,27,3,28,17,30,27,31];%case study niniload小车A轨迹数据
% A=[0 1 3 2 4 3 3 5 5 6 1 0 ];
% B=[11 9 7 7 7 10 8 6 4 6 8 11];
t=0;
xA=[A(1)];%A的轨迹数据；
xB=[B(1)];%B的轨迹数据；
% 小车1和小车2的任务都是从序列的第二个位置开始的，序列初始位置为小车的停放点
flagA=2;%A的任务点
flagB=2;
k1=2;
k2=2;
ljA=[A(1),A(2),1];%设定A的初始路径,分别代表此时位置，要去的点，1代表非卸货，0代表卸货中
ljB=[B(1),B(2),1];%设定B的初始路径
while k1 && k2%一直循环到A,B其中一个回到各自的初始点
  % <--A      B-->   
  if ljA(1)>=ljA(2) && ljB(1)<=ljB(2) %反向而行
      %A的部分
      if (ljA(1)-ljA(2))==0 && ljA(3)==0 %%A在目前卸货点，且上一秒开始卸货
          if A(flagA+1)==A(flagA) %之后还有这个点得任务
            xA=[xA,ljA(1)];
            flagA=flagA+1;
            ljA=[ljA(1),A(flagA),0];             
          else                    %之后没有这个点得任务
            xA=[xA,ljA(1)];
            flagA=flagA+1;        %任务点更新为下一个
            ljA=[ljA(1),A(flagA),1];
          end
      elseif (ljA(1)-ljA(2))~=0 %A还未到任务点
           xA=[xA,ljA(1)-1];
           ljA=[ljA(1)-1,A(flagA),1];
           if ljA(1)==ljA(2)
              ljA(3)=0;
           end
      end
      %B的部分
      if (ljB(1)-ljB(2))==0 && ljB(3)==0 %%B在目前卸货点，且上一秒开始卸货
         if B(flagB+1)==B(flagB) %之后还有这个点得任务
            xB=[xB,ljB(1)];
            flagB=flagB+1;
            ljB=[ljB(1),B(flagB),0];             
         else                    %之后没有这个点得任务
            xB=[xB,ljB(1)];
            flagB=flagB+1;
            ljB=[ljB(1),B(flagB),1];
         end
      elseif (ljB(1)-ljB(2))~=0 %B还未到任务点
           xB=[xB,ljB(1)+1];
           ljB=[ljB(1)+1,B(flagB),1];
           if ljB(1)==ljB(2)
              ljB(3)=0;
           end
      end
  %end
  
  elseif (ljA(1)<=ljA(2) && ljB(1)<=ljB(2)) || (ljA(1)>=ljA(2) && ljB(1)>=ljB(2)) %A,B同向运动
      if ljA(1)+1<ljB(1) %A,B下一秒不会相撞
         %A的部分
         if (ljA(1)-ljA(2))==0 && ljA(3)==0 %%A在目前卸货点，且上一秒开始卸货
            if A(flagA+1)==A(flagA) %之后还有这个点得任务
               xA=[xA,ljA(1)];
               flagA=flagA+1;
               ljA=[ljA(1),A(flagA),0];             
            else                    %之后没有这个点得任务
               xA=[xA,ljA(1)];
               flagA=flagA+1;
               ljA=[ljA(1),A(flagA),1];
            end
         elseif (ljA(1)-ljA(2))~=0 %A还未到任务点
            xA=[xA,ljA(1)+(ljA(2)-ljA(1))/abs(ljA(2)-ljA(1))];
            ljA=[ljA(1)+(ljA(2)-ljA(1))/abs(ljA(2)-ljA(1)),A(flagA),1];
            if ljA(1)==ljA(2)
               ljA(3)=0;
            end
         end
         %B的部分
         if (ljB(1)-ljB(2))==0 && ljB(3)==0 %%B在目前卸货点，且上一秒开始卸货
             if B(flagB+1)==B(flagB) %之后还有这个点得任务
                xB=[xB,ljB(1)];
                flagB=flagB+1;
                ljB=[ljB(1),B(flagB),0];             
             else                    %之后没有这个点得任务
                xB=[xB,ljB(1)];
                flagB=flagB+1;
                ljB=[ljB(1),B(flagB),1];
             end
         elseif (ljB(1)-ljB(2))~=0 %B还未到任务点
            xB=[xB,ljB(1)+(ljB(2)-ljB(1))/abs(ljB(2)-ljB(1))];
            ljB=[ljB(1)+(ljB(2)-ljB(1))/abs(ljB(2)-ljB(1)),B(flagB),1];
            if ljB(1)==ljB(2)
               ljB(3)=0;
            end
         end  
      else           %A，B下一秒可能相撞
          if ljA(3)==1 && ljA(1)==ljA(2) && ljB(2)<ljB(1) %A刚到任务点，B向A运动
             xA=[xA,ljA(1)];
             flagA=flagA+1;
             ljA=[ljA(1),A(flagA),0]; 
             xB=[xB,ljB(1)];  %B等待A
          elseif ljA(3)==0 && ljA(1)==ljA(2) && ljB(2)<ljB(1) %A上一秒开始工作，B向A运动
             if A(flagA+1)==A(flagA) %之后还有这个点得任务
               xA=[xA,ljA(1)];
               flagA=flagA+1;
               ljA=[ljA(1),A(flagA),0];             
             else                    %之后没有这个点得任务
               xA=[xA,ljA(1)];
               flagA=flagA+1;
               ljA=[ljA(1),A(flagA),1];
             end             
             xB=[xB,ljB(1)];  %B等待A
          elseif ljB(3)==1 && ljB(1)==ljB(2) && ljA(2)>ljA(1) %B刚到任务点，A向B运动
             xB=[xB,ljB(1)];
             flagB=flagB+1;
             ljB=[ljB(1),B(flagB),0]; 
             xA=[xA,ljA(1)];  %A等待B          
          elseif ljB(3)==0 && ljB(1)==ljB(2) && ljA(2)>ljA(1) %B上一秒开始工作，B向A运动
             if B(flagB+1)==B(flagB) %之后还有这个点得任务
               xB=[xB,ljB(1)];
               flagB=flagB+1;
               ljB=[ljB(1),B(flagB),0];             
             else                    %之后没有这个点得任务
               xB=[xB,ljB(1)];
               flagB=flagB+1;
               ljB=[ljB(1),B(flagB),1];
             end             
             xA=[xA,ljA(1)];  %A等待B
          elseif ljA(1)==ljA(2) && ljB(1)==ljB(2)  %A,B同时在任务点
             if A(flagA+1)==A(flagA) %之后还有这个点得任务
               xA=[xA,ljA(1)];
               flagA=flagA+1;
               ljA=[ljA(1),A(flagA),0];             
             else                    %之后没有这个点得任务
               xA=[xA,ljA(1)];
               flagA=flagA+1;
               ljA=[ljA(1),A(flagA),1];
             end 
             if B(flagB+1)==B(flagB) %之后还有这个点得任务
               xB=[xB,ljB(1)];
               flagB=flagB+1;
               ljB=[ljB(1),B(flagB),0];             
             else                    %之后没有这个点得任务
               x=[xB,ljB(1)];
               flagB=flagB+1;
               ljB=[ljB(1),B(flagB),1];
             end
          else
              xA=[xA,ljA(1)+(ljA(2)-ljA(1))/abs(ljA(2)-ljA(1))];
              ljA(1)=ljA(1)+(ljA(2)-ljA(1))/abs(ljA(2)-ljA(1));
              if ljA(1)==ljA(2)
                  ljA(3)=0;
              end
              xB=[xB,ljB(1)+(ljB(2)-ljB(1))/abs(ljB(2)-ljB(1))];
              ljB(1)=ljB(1)+(ljB(2)-ljB(1))/abs(ljB(2)-ljB(1));
              if ljB(1)==ljB(2)
                  ljB(3)=0;
              end             
          end                        
      end      
  
  elseif ljA(1)<ljA(2) && ljB(1)>ljB(2) %A，B相对运动
     if ljA(1)+2<ljB(1) %A,B不会相撞
        xA=[xA,ljA(1)+1];
        ljA=[ljA(1)+1,A(flagA),1];
        if ljA(1)==ljA(2)
            ljA(3)=0;
        end
        xB=[xB,ljB(1)-1];
        ljB=[ljB(1)-1,B(flagB),1];
        if ljB(1)==ljB(2)
            ljB(3)=0;
        end
     else
         %设定规则：离任务点近的车优先级更高，B车让A车
        if ljA(1)+1==ljB(1)  %A,B相邻
           if ljA(2)-ljA(1)<=ljB(1)-ljB(2)
              xA=[xA,ljA(1)+1];
              ljA=[ljA(1)+1,A(flagA),1];
              if ljA(1)==ljA(2)
                    ljA(3)=0;
              end
              if ljB(1)<B(1)
                 xB=[xB,ljB(1)+1];
                 ljB=[ljB(1)+1,B(flagB),1];
              else
                 xB=[xB,ljB(1)];
                 ljB=[ljB(1),B(flagB),1];                  
              end
           else
              xB=[xB,ljB(1)-1];
              ljB=[ljB(1)-1,B(flagB),1];
              if ljB(1)==ljB(2)
                    ljB(3)=0;
              end
              if ljA(1)>A(1)
                 xA=[xA,ljA(1)-1];
                 ljA=[ljA(1)-1,A(flagA),1];
              else
                 xA=[xA,ljA(1)];
                 ljA=[ljA(1),A(flagA),1];                  
              end               
           end
        elseif ljA(1)+2==ljB(1)
           if ljA(2)-ljA(1)<=ljB(1)-ljB(2)
              xA=[xA,ljA(1)+1];
              ljA=[ljA(1)+1,A(flagA),1];
              xB=[xB,ljB(1)];              
           else
              xB=[xB,ljB(1)-1];
              ljB=[ljB(1)-1,B(flagB),1];
              xA=[xA,ljA(1)];             
           end
        end
     end
  end
  if flagA==length(A)
      k1=0;
  end
  if flagB==length(B)
      k2=0;
  end
  t=t+1;%进行下一秒的循环    
end


%以上循环结束，说明有一辆车完成了最后一个任务点
if k1==0
   while ljA(1)-A(1) 
     ljA(1)=ljA(1)-1;
     xA=[xA,ljA(1)]; 
   end
   %A最后路径
   while flagB~=length(B)
       if ljB(3)==0 && B(flagB)~=B(flagB+1)
          flagB=flagB+1;
          ljB=[ljB(1),B(flagB),1];
          xB=[xB,ljB(1)];
       elseif ljB(3)==0 && B(flagB)==B(flagB+1)
          flagB=flagB+1;
          ljB=[ljB(1),B(flagB),0];
          xB=[xB,ljB(1)];           
       else
          ljB=[ljB(1)+(ljB(2)-ljB(1))/abs(ljB(2)-ljB(1)),B(flagB),1];
          xB=[xB,ljB(1)]; 
          if ljB(1)==ljB(2)
              ljB(3)=0;
          end
       end
   end
   while B(1)-ljB(1) 
     ljB(1)=ljB(1)+1; 
     xB=[xB,ljB(1)]; 
   end
   %B最后路径
else
   while B(1)-ljB(1) 
     ljB(1)=ljB(1)+1;
     xB=[xB,ljB(1)]; 
   end 
   %B最后路径
   while flagA~=length(A)
       if ljA(3)==0 && A(flagA)~=A(flagA+1)
          flagA=flagA+1;
          ljA=[ljA(1),A(flagA),1];
          xA=[xA,ljA(1)];
       elseif ljA(3)==0 && A(flagA)==A(flagA+1)
          flagA=flagA+1;
          ljA=[ljA(1),A(flagA),0];
          xA=[xA,ljA(1)];
       else
          ljA=[ljA(1)+(ljA(2)-ljA(1))/abs(ljA(2)-ljA(1)),A(flagA),1];
          xA=[xA,ljA(1)]; 
          if ljA(1)==ljA(2)
              ljA(3)=0;
          end
       end
   end
   while ljA(1)-A(1) 
     ljA(1)=ljA(1)-1; 
     xA=[xA,ljA(1)]; 
   end
   %A最后路径
end
tA=length(xA)-1;
tB=length(xB)-1;
if length(xA)>=length(xB)
    xB=[xB,B(length(B))*ones(1,length(xA)-length(xB))];
else
    xA=[xA,A(length(A))*ones(1,length(xB)-length(xA))];
end
T=0:max(length(xA),length(xB))-1;
plot(T,xA,'r',T,xB,'b');
xlabel('Time(s)');
ylabel('Position');
legend('S/R1','S/R2')
fprintf('A小车的总运动时间%d\n',tA);
fprintf('B小车的总运动时间%d\n',tB);
