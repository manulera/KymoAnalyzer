
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
drawStars(y,test.Var2,[0.05,0.005,0.0005],13,[],{'fontsize',insets_fontsize})
writeMeanNSem(y,10,[],{'fontsize',insets_fontsize})

ylabel(['Duration (s)'])
apply_dictionary_xticks(condition_dict)
print_pdf([target_folder filesep 'duration.pdf' ])

%% Plot the rescue respect to center
figure('Position',[744   630   420   420])
[~,y]=UnivarScatter(this_data(normal_events,{'condition_name','rescue_respect2center'}),univar_settings{:});
test=doKstest2(this_data{normal_events,'rescue_respect2center'},this_data.condition_name(normal_events),'ctrl',@ttest2);
drawStars(y,test.Var2,[0.05,0.005,0.0005],0.4,[],{'fontsize',insets_fontsize})
writeMeanNSem(y,0.3,[],{'fontsize',insets_fontsize},1)
ylabel(['Rescue respect to center (' 956 'm)'])
hline(0,'k:')
apply_dictionary_xticks(condition_dict)
print_pdf([target_folder filesep 'rescue_respect2center.pdf' ])


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
scatterWithAveLine(this_data,'length_spindle_start','speed_min',color_dict,condition_dict,5,0:1:12)

xlim([3,12])
legend('Location','Best')
xlabel(['Spindle length (' 956 'm)'])
ylabel(['Growth speed (' 956 'm/min)'])
print_pdf([target_folder filesep 'speed.pdf' ])

%%
% figure('Position',[744   630   420   420])
figure
hold on
scatterWithAveLine(this_data,'rescue_respect2pole','speed_min',color_dict,condition_dict,5,0:1:6)

xlim([0.5,6])
legend('Location','Best')
xlabel(['Rescue respect to pole (' 956 'm)'])
ylabel(['Growth speed (' 956 'm/min)'])
print_pdf([target_folder filesep 'speed2.pdf' ])

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
    scatterWithAveLine(custom_data,'rescue_respect2pole','speed_min',color_dict,condition_dict,10,-4:0.75:2)
    
%     text(this_data.rescue_respect2membrane,this_data.speed_min,this_data.unique_id)
    
    legend('Location','Best')
    xlabel(['Rescue respect to membrane edge (' 956 'm)'])
    ylabel(['Growth speed (' 956 'm/min)'])
    xlim([0,5])
%     print_pdf([target_folder filesep 'speed.pdf' ])
end
%%
figure
hold on

scatterWithAveLine(this_data,'rescue_respect2pole','rescue_respect2membrane',color_dict,condition_dict,10,-4:0.75:2)

%%
figure('Position',[744   630   420   420])
withMemb = ~isundefined(this_data.rescue_inside_membrane);
[~,y]=UnivarScatter(this_data(withMemb,{'rescue_inside_membrane','speed_min'}),univar_settings{:});
test=doKstest2(this_data{withMemb,'speed_min'},this_data.rescue_inside_membrane(withMemb),'ctrl',@ttest2);
drawStars(y,test.Var2,[0.05,0.005,0.0005],13,[],{'fontsize',insets_fontsize})
writeMeanNSem(y,10,[],{'fontsize',insets_fontsize})

ylabel(['Duration (s)'])
% apply_dictionary_xticks(condition_dict)