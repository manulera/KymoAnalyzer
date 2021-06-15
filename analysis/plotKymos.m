
if ~isfolder(target_folder)
    mkdir(target_folder);
end

this_data.condition_name = removeCategories(this_data.condition_name);
categories(this_data.condition_name);
this_data.condition_name = reordercats(this_data.condition_name,category_order);

% Remove shrinking events
this_data(this_data.is_special==2 | this_data.speed<0,:)=[];

% Set the colors and plotting settings
colors = collapseColors(color_dict,this_data.condition_name);
univar_settings = {'MarkerFaceColor',colors};
whiskers_settings = {'Whiskers','lines','SEMColor','k','StdColor','k','MarkerEdgeColor','white','LineWidth',1,'PointSize',40};
univar_settings = [univar_settings whiskers_settings];
normal_events = this_data.is_special==0;

%% Plot the duration
figure('Position',[744   630   420   420])
[~,y]=UnivarScatter(this_data(normal_events,{'condition_name','duration'}),univar_settings{:});
test=doKstest2(this_data{normal_events,'duration'},this_data.condition_name(normal_events),'ctrl',@ttest2);
drawStars(y,test.Var2,[0.05,0.005,0.0005],13,[],false,{'fontsize',insets_fontsize})
writeMeanNSem(y,10,[],{'fontsize',insets_fontsize})

ylabel(['Duration (s)'])
apply_dictionary_xticks(condition_dict)
print_pdf([target_folder filesep 'duration.pdf' ])


%%
figure('Position',[744   630   420   420])
hold on
clear_events = this_data.is_special==0;
scatterWithAveLine(this_data(clear_events,:),'length_spindle_start','rescue_respect2center',color_dict,condition_dict,3)
hline([-1.25,0,1.25],'k:')
xlim([3,13])
legend('Location','Best')
xlabel(['Spindle length (' 956 'm)'])
ylabel(['Rescue respect to center (' 956 'm)'])


%%
figure('Position',[744   630   420   420])
hold on
scatterWithAveLine(this_data(clear_events,:),'length_spindle_start','duration',color_dict,condition_dict,3)
hline([0],'k:')
xlim([3,13])
legend('Location','Best')
xlabel(['Spindle length (' 956 'm)'])
ylabel(['Duration (s)'])
%%
% figure('Position',[744   630   420   420])
figure
hold on
scatterWithAveLine(this_data,'length_spindle_start','speed_min',color_dict,condition_dict,10,0:1.5:16)

xlim([3,16])
legend('Location','Best')
xlabel(['Spindle length (' 956 'm)'])
ylabel(['Growth speed (' 956 'm/min)'])
print_pdf([target_folder filesep 'speed.pdf' ])

%%
% figure('Position',[744   630   420   420])
figure
hold on
scatterWithAveLine(this_data,'rescue_respect2pole','speed_min',color_dict,condition_dict,5,0.5:1.5:8)

xlim([0.5,6])
legend('Location','Best')
xlabel(['Rescue respect to pole (' 956 'm)'])
ylabel(['Growth speed (' 956 'm/min)'])
print_pdf([target_folder filesep 'speed2.pdf' ])
%%
figure
hold on
scatterWithAveLine(this_data,'rescue_respect2membrane','speed_min',color_dict,condition_dict,5,-8.5:8)


legend('Location','Best')
xlabel(['Rescue respect to membrane (' 956 'm)'])
ylabel(['Growth speed (' 956 'm/min)'])


%% Plot the 
if any(~isnan(this_data.rescue_respect2membrane))
    figure
    hold on
    custom_data = this_data;
    custom_data.condition_name = custom_data.rescue_inside_membrane;
    color_dict('before')=color_dict('cdc25-22');
    color_dict('inside')=color_dict('ase1D');
    color_dict('outside')=color_dict('p81cls1');
    condition_dict('before') = 'before';
    condition_dict('inside') = 'inside';
    condition_dict('outside') = 'outside';
    scatterWithAveLine(custom_data,'rescue_respect2membrane','speed_min',color_dict,condition_dict,10,-4:0.75:2)
    
%     text(this_data.rescue_respect2membrane,this_data.speed_min,this_data.unique_id)
    
    legend('Location','Best')
    xlabel(['Rescue respect to membrane edge (' 956 'm)'])
%     xlabel(['Spindle length (' 956 'm)'])
    ylabel(['Growth speed (' 956 'm/min)'])
%     xlim([0,5])
%     print_pdf([target_folder filesep 'speed.pdf' ])
end
%%
figure
hold on
scatterWithAveLine(custom_data,'rescue_respect2pole','rescue_respect2membrane',color_dict,condition_dict,10,-4:0.75:2)
legend('Location','Best')
xlabel('Rescue respect to pole (um)')
ylabel('Rescue respect to membrane (um)')
hline(0)

%%
figure('Position',[744   630   420   420])
% Set the colors and plotting settings
colors = collapseColors(color_dict,this_data.rescue_inside_membrane);
univar_settings = {};
whiskers_settings = {'Whiskers','lines','SEMColor','k','StdColor','k','MarkerEdgeColor','white','LineWidth',1,'PointSize',40};
univar_settings = [univar_settings whiskers_settings];

this_data.composed_condition = cell(size(this_data,1),1);

for i = 1:size(this_data,1)
    this_data.composed_condition{i} = sprintf('%s %s',this_data.rescue_inside_membrane(i), this_data.condition_name(i));
end

withMemb = ~isundefined(this_data.rescue_inside_membrane);
[~,y]=UnivarScatter(this_data(withMemb,{'composed_condition','speed_min'}),univar_settings{:});
% test=doKstest2(this_data{withMemb,'speed_min'},this_data.rescue_inside_membrane(withMemb),'ctrl',@ttest2);
% drawStars(y,test.Var2,[0.05,0.005,0.0005],13,[],{'fontsize',insets_fontsize})
% writeMeanNSem(y,10,[],{'fontsize',insets_fontsize})
xtickangle(45)
ylabel(['Velocity (um/min)'])
% apply_dictionary_xticks(condition_dict)
%%
