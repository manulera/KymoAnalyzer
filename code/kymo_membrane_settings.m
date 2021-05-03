function [handles] = kymo_membrane_settings(handles)
    
    if handles.tog_memb.Value
        % In membrane mode, we try to load either the membrane or the probs,
        % and we change the contrast

        if isfile([handles.pathfile filesep 'probs_membrane_mean_kymo.tif'])
            handles.tif_file = 'probs_membrane_mean_kymo.tif';
            handles.kymo = imread([handles.pathfile filesep handles.tif_file]);
        else
            handles.tif_file = 'movie_membrane_mean_kymo.tif';
            handles.kymo = imread([handles.pathfile filesep handles.tif_file]);
        end

        handles.int_low_lim = 0;
        handles.int_high_lim = 200;
    end
end

