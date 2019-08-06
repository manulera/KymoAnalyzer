
[~,out] = system('find . -type f -name "kymo_save.mat"');

all_files = strsplit(out);
empty_ones = cellfun('isempty',all_files);
all_files = all_files(~empty_ones);

%% 
% length_starts, length_catastropy, length_spindle_start,
% length_spindle_catast, duration, speed, exp_id
extracted = [];

for i = 1:numel(all_files)

    load(all_files{i})
    for j = 1:numel(out.kymo_lines)
        kl = out.kymo_lines{j};
        lens = kl.mt_length(out);
        add = [lens(1),lens(end),out.spindle_length(kl.y(1)),out.spindle_length(kl.y(end)), ...
            numel(kl.x),kl.speed,   i];
        add(5) = add(5)*out.info.timestep;
        add(1:4) = add(1:4)*out.info.resolution;
        extracted = [extracted; add];
    end

end

extracted()

%%

figure
scatter(extracted(:,3),extracted(:,1),'DisplayName','Rescue')
hold on
scatter(extracted(:,4),extracted(:,2),'DisplayName','Catastrophe')
legend()
xlabel('Spindle length (um)')
ylabel('Position of event with respect to pole (um)')

%%
figure
scatter(extracted(:,3),extracted(:,1)-extracted(:,3)/2,'DisplayName','Rescue')
hold on

scatter(extracted(:,4),extracted(:,2)-extracted(:,4)/2,'DisplayName','Catastrophe')
xlabel('Spindle length (um)')
ylabel('Position of event with respect to center (um)')
legend()

%%
figure
hold on
histogram(extracted(:,1)-extracted(:,3)/2)
histogram(extracted(:,2)-extracted(:,4)/2)
xlabel('Position of event with respect to center (um)')
ylabel('Count')


%%

figure
scatter(mean(extracted(:,3:4),2),extracted(:,5))
xlabel('Average length of spindle during event (um)')
ylabel('Duration of the event (s)')

%%
figure
hold on
histogram(extracted(:,5))
xlabel('Duration of the event (s)')
ylabel('Count')
%%


figure
scatter(mean(extracted(:,3:4),2),extracted(:,6))
xlabel('Average length of spindle during event (um)')
ylabel('Speed (um/s)')
%%
figure
hold on
histogram(extracted(:,6))
xlabel('Speed (um/s)')
ylabel('Count')


%%
figure
scatter(mean(extracted(:,3:4),2),diff(extracted(:,1:2),[],2))
xlabel('Average length of spindle during event (um)')
ylabel('Growth length (um)')
%%
ave_center = mean([extracted(:,1)-extracted(:,3)/2,extracted(:,2)-extracted(:,4)/2],2);

figure
scatter(ave_center,diff(extracted(:,1:2),[],2))

ylabel('Growth length (um)')
xlabel('Average position of event with respect to center (um)')