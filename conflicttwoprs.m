clc;
clear;
% ����A�ĳ�ʼλ��Ϊ0��B�ĳ�ʼλ��Ϊ31
A=[0 10	11	24	29	2	2	13	30	6	9	6	25	3	3	20 23	14	6	3	1	11	28	6	9	1	11	9	13	4	9 0];%case studyС��A�켣����
B=[ 31  25	27	22	20	17	24	27	20	18	3	30	19	20	1	30 28	17	24	27	23	17	15	13	12	30	24	10	18	24	23 31];%case studyС��B�켣����
%A=[0,2,11,28,30,3,4,9,20,6,10,24,25,1,3,1,3,11,23,11,29,6,9,9,13,2,13,9,6,14,6,0];%case study niniloadС��A�켣����
%B=[31,24,23,30,30,10,1,15,12,19,20,20,18,20,25,24,24,18,22,17,23,17,24,13,25,27,27,3,28,17,30,27,31];%case study niniloadС��A�켣����
% A=[0 1 3 2 4 3 3 5 5 6 1 0 ];
% B=[11 9 7 7 7 10 8 6 4 6 8 11];
t=0;
xA=[A(1)];%A�Ĺ켣���ݣ�
xB=[B(1)];%B�Ĺ켣���ݣ�
% С��1��С��2�������Ǵ����еĵڶ���λ�ÿ�ʼ�ģ����г�ʼλ��ΪС����ͣ�ŵ�
flagA=2;%A�������
flagB=2;
k1=2;
k2=2;
ljA=[A(1),A(2),1];%�趨A�ĳ�ʼ·��,�ֱ�����ʱλ�ã�Ҫȥ�ĵ㣬1�����ж����0����ж����
ljB=[B(1),B(2),1];%�趨B�ĳ�ʼ·��
while k1 && k2%һֱѭ����A,B����һ���ص����Եĳ�ʼ��
  % <--A      B-->   
  if ljA(1)>=ljA(2) && ljB(1)<=ljB(2) %�������
      %A�Ĳ���
      if (ljA(1)-ljA(2))==0 && ljA(3)==0 %%A��Ŀǰж���㣬����һ�뿪ʼж��
          if A(flagA+1)==A(flagA) %֮��������������
            xA=[xA,ljA(1)];
            flagA=flagA+1;
            ljA=[ljA(1),A(flagA),0];             
          else                    %֮��û������������
            xA=[xA,ljA(1)];
            flagA=flagA+1;        %��������Ϊ��һ��
            ljA=[ljA(1),A(flagA),1];
          end
      elseif (ljA(1)-ljA(2))~=0 %A��δ�������
           xA=[xA,ljA(1)-1];
           ljA=[ljA(1)-1,A(flagA),1];
           if ljA(1)==ljA(2)
              ljA(3)=0;
           end
      end
      %B�Ĳ���
      if (ljB(1)-ljB(2))==0 && ljB(3)==0 %%B��Ŀǰж���㣬����һ�뿪ʼж��
         if B(flagB+1)==B(flagB) %֮��������������
            xB=[xB,ljB(1)];
            flagB=flagB+1;
            ljB=[ljB(1),B(flagB),0];             
         else                    %֮��û������������
            xB=[xB,ljB(1)];
            flagB=flagB+1;
            ljB=[ljB(1),B(flagB),1];
         end
      elseif (ljB(1)-ljB(2))~=0 %B��δ�������
           xB=[xB,ljB(1)+1];
           ljB=[ljB(1)+1,B(flagB),1];
           if ljB(1)==ljB(2)
              ljB(3)=0;
           end
      end
  %end
  
  elseif (ljA(1)<=ljA(2) && ljB(1)<=ljB(2)) || (ljA(1)>=ljA(2) && ljB(1)>=ljB(2)) %A,Bͬ���˶�
      if ljA(1)+1<ljB(1) %A,B��һ�벻����ײ
         %A�Ĳ���
         if (ljA(1)-ljA(2))==0 && ljA(3)==0 %%A��Ŀǰж���㣬����һ�뿪ʼж��
            if A(flagA+1)==A(flagA) %֮��������������
               xA=[xA,ljA(1)];
               flagA=flagA+1;
               ljA=[ljA(1),A(flagA),0];             
            else                    %֮��û������������
               xA=[xA,ljA(1)];
               flagA=flagA+1;
               ljA=[ljA(1),A(flagA),1];
            end
         elseif (ljA(1)-ljA(2))~=0 %A��δ�������
            xA=[xA,ljA(1)+(ljA(2)-ljA(1))/abs(ljA(2)-ljA(1))];
            ljA=[ljA(1)+(ljA(2)-ljA(1))/abs(ljA(2)-ljA(1)),A(flagA),1];
            if ljA(1)==ljA(2)
               ljA(3)=0;
            end
         end
         %B�Ĳ���
         if (ljB(1)-ljB(2))==0 && ljB(3)==0 %%B��Ŀǰж���㣬����һ�뿪ʼж��
             if B(flagB+1)==B(flagB) %֮��������������
                xB=[xB,ljB(1)];
                flagB=flagB+1;
                ljB=[ljB(1),B(flagB),0];             
             else                    %֮��û������������
                xB=[xB,ljB(1)];
                flagB=flagB+1;
                ljB=[ljB(1),B(flagB),1];
             end
         elseif (ljB(1)-ljB(2))~=0 %B��δ�������
            xB=[xB,ljB(1)+(ljB(2)-ljB(1))/abs(ljB(2)-ljB(1))];
            ljB=[ljB(1)+(ljB(2)-ljB(1))/abs(ljB(2)-ljB(1)),B(flagB),1];
            if ljB(1)==ljB(2)
               ljB(3)=0;
            end
         end  
      else           %A��B��һ�������ײ
          if ljA(3)==1 && ljA(1)==ljA(2) && ljB(2)<ljB(1) %A�յ�����㣬B��A�˶�
             xA=[xA,ljA(1)];
             flagA=flagA+1;
             ljA=[ljA(1),A(flagA),0]; 
             xB=[xB,ljB(1)];  %B�ȴ�A
          elseif ljA(3)==0 && ljA(1)==ljA(2) && ljB(2)<ljB(1) %A��һ�뿪ʼ������B��A�˶�
             if A(flagA+1)==A(flagA) %֮��������������
               xA=[xA,ljA(1)];
               flagA=flagA+1;
               ljA=[ljA(1),A(flagA),0];             
             else                    %֮��û������������
               xA=[xA,ljA(1)];
               flagA=flagA+1;
               ljA=[ljA(1),A(flagA),1];
             end             
             xB=[xB,ljB(1)];  %B�ȴ�A
          elseif ljB(3)==1 && ljB(1)==ljB(2) && ljA(2)>ljA(1) %B�յ�����㣬A��B�˶�
             xB=[xB,ljB(1)];
             flagB=flagB+1;
             ljB=[ljB(1),B(flagB),0]; 
             xA=[xA,ljA(1)];  %A�ȴ�B          
          elseif ljB(3)==0 && ljB(1)==ljB(2) && ljA(2)>ljA(1) %B��һ�뿪ʼ������B��A�˶�
             if B(flagB+1)==B(flagB) %֮��������������
               xB=[xB,ljB(1)];
               flagB=flagB+1;
               ljB=[ljB(1),B(flagB),0];             
             else                    %֮��û������������
               xB=[xB,ljB(1)];
               flagB=flagB+1;
               ljB=[ljB(1),B(flagB),1];
             end             
             xA=[xA,ljA(1)];  %A�ȴ�B
          elseif ljA(1)==ljA(2) && ljB(1)==ljB(2)  %A,Bͬʱ�������
             if A(flagA+1)==A(flagA) %֮��������������
               xA=[xA,ljA(1)];
               flagA=flagA+1;
               ljA=[ljA(1),A(flagA),0];             
             else                    %֮��û������������
               xA=[xA,ljA(1)];
               flagA=flagA+1;
               ljA=[ljA(1),A(flagA),1];
             end 
             if B(flagB+1)==B(flagB) %֮��������������
               xB=[xB,ljB(1)];
               flagB=flagB+1;
               ljB=[ljB(1),B(flagB),0];             
             else                    %֮��û������������
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
  
  elseif ljA(1)<ljA(2) && ljB(1)>ljB(2) %A��B����˶�
     if ljA(1)+2<ljB(1) %A,B������ײ
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
         %�趨�������������ĳ����ȼ����ߣ�B����A��
        if ljA(1)+1==ljB(1)  %A,B����
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
  t=t+1;%������һ���ѭ��    
end


%����ѭ��������˵����һ������������һ�������
if k1==0
   while ljA(1)-A(1) 
     ljA(1)=ljA(1)-1;
     xA=[xA,ljA(1)]; 
   end
   %A���·��
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
   %B���·��
else
   while B(1)-ljB(1) 
     ljB(1)=ljB(1)+1;
     xB=[xB,ljB(1)]; 
   end 
   %B���·��
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
   %A���·��
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
fprintf('AС�������˶�ʱ��%d\n',tA);
fprintf('BС�������˶�ʱ��%d\n',tB);
