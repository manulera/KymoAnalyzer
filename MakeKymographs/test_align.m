s1 = im_profiles{12};
s2 = im_profiles{13};
X1=xcorr(s1,s2);   %compute cross-correlation between vectors s1 and s2
[m,d]=max(X1);      %find value and index of maximum value of cross-correlation amplitude
delay=d-max(length(s1),length(s2));   %shift index d, as length(X1)=2*N-1; where N is the length of the signals
figure,plot(s1)                                     %Plot signal s1
hold,plot([delay+1:length(s2)+delay],s2,'r');   


delay