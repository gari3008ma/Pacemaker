Coding aspect:
i=importdata('ecg_temp_data2.txt');
ard=arduino('com3');
[n,p] = size(i);
a = i(:,1);
t = i(:,1);
b = i(:,2);
m = mean(b);
c = b - m;
 p = polyfit(a, c, 5); 
 e = polyval(p,a);
 z = c - e;
 ard.pinMode(6,'output');
 
 %for r peak..
s = 1; 
  for i = 2:1279
if z(i-1) < z(i) & z(i) > z(i+1);
if z(i) > 0.4;
pks(s) = z(i);
s = s+1;
end
end
end
for i = 1:17
idx = find(z==pks(i));
x(i) = a(idx);

end
subplot(3,2,1);
plot(a,z);
grid
hold on
plot(x, pks, 'o');
title('input ecg');
%heart rate variability..
r = 1;
for i = 2:17
p2p(r) = x(i) - x(i-1);
r = r+1;
end

for i = 1:16
hrv(i) = 60/p2p(i);
hrv(i) = hrv(i) - 40;
if hrv(i) < 0;
hrv(i) = hrv(i)*-1;
end
end

beat = 1:16;
subplot(3,2,2);
plot(beat, hrv);
title('heart rate as calculated by input ecg');
xlabel('beats');
ylabel('instantaneous rate');
grid;

for i = 1:16;
    if p2p(i) <= 0.6 && i ~= 16;
        
            pp(i) = p2p(i);
        
    else
        pp(i) = 0.5;
        i=i+1;
    end
end
   
for i = 1:16
hr(i) = 60/pp(i);
hr(i) = hr(i)-40;
if hr(i) < 0;
hr(i) = hr(i)*-1;
end
end
beat = 1:16;
subplot(3,2,6);
plot(beat, hr);
title('projected heart rate correction');
xlabel('beats');
ylabel('instantaneous rate');
grid;

j=0;
for j = 149:232;
    t(j) = (t(j)-.0018);
end
for j =307:385
    t(j) = t(j)-(1.1538e-04);
end
for j =441:521;
    t(j) = t(j)-0.0016;
end
for j =522:601;
    t(j) = t(j)-0.0016;
end
for j =602:679;
    t(j) = t(j)-0.0014;
end
for j =831:751;
    t(j) = t(j)-0.0016;
end
for j=752:924;
    t(j) = t(j)-0.0018;
end
for j =1074:1173;
    t(j) = t(j)-0.0017;
end
for j =1174:1280;
    t(j) = t(j)-0.0015;
end
subplot(3,2,3);
plot(a,z);
hold on
plot(t,z,'r');
grid;
plot(x, pks, 'o');

xx = 1;
for i = 1:16;
if hrv(i) < 60;
    pace(xx)=i;
    xx = xx+1;
    i = i+1;
end
end
xx=1;

for i=1:16;
    if i == pace(xx);
        
        x1 =[i,i];
        y1 =[0,5];
        ard.digitalWrite(6,1);
        pause(.5);
        ard.digitalWrite(6,0); 
        pause(.5);
        xx = xx+1;
        subplot(3,2,4);
        title('pacemaker output for elevating the lowered heart rate');
        ylim([0 20]);
        xlim([0 16]);
        plot(x1,y1);
        grid;
        hold on;
       
    else 
        i = i+1;   
end
end

delete(ard);
