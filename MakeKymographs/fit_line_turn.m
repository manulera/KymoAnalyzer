%% Generate noisy data
% slope
a = 1;

b = 0;

x = linspace(-4,8);

y = a*x + b + rand(1,numel(x))*3;

pars = fitLineAngle(x,y);

figure
hold on
scatter(x,y)
d = linspace(-10,10);
vect = [cos(pars(1)), sin(pars(1))];
x = pars(2)+vect(1)*d;
y = pars(3)+vect(2)*d;

plot(x,y)

