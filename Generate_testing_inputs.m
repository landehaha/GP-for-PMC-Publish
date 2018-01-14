 TestX = rand(1000000,8);
 m = length(TestX);
for i = 1:m
    if TestX(i,1)+TestX(i,2)>1||TestX(i,3)+TestX(i,4)>1||TestX(i,5)+TestX(i,6)>1;
        TestX(i,:)= 0;        
    end
end
TestX(all(TestX==0,2),:)=[];
xlswrite('Test100000.xlsx',TestX);