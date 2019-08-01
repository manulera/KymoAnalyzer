function [h] = kymo_update(h)
    if true||~isfield(h,'version')||h.version<1.0
        for i = 1:numel(h.kymo_lines)
            h.kymo_lines{i}.interpolate(size(h.kymo,1))
        end
        if isfield(h,'right_edge')
            h.right_edge.interpolate(size(h.kymo,1))
            h.right_edge.extend_edge(size(h.kymo,1))
        end
        if isfield(h,'left_edge')
            h.left_edge.interpolate(size(h.kymo,1))
            h.left_edge.extend_edge(size(h.kymo,1))
        end
    end
end

