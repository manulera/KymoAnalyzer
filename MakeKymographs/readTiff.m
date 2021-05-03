function [outp] = readTiff(file)
    
    % Ignore warnings
    warning('off','MATLAB:imagesci:tiffmexutils:libtiffWarning')    
    inp = Tiff(file);
    nb_frames = size(imfinfo(file),1);
    
    outp = zeros([inp.getTag('ImageLength') inp.getTag('ImageWidth') nb_frames]);
    
    
    for i = 1:nb_frames
        inp.setDirectory(i);
        outp(:,:,i) = inp.read();
    end
    warning('on','MATLAB:imagesci:tiffmexutils:libtiffWarning')
end

