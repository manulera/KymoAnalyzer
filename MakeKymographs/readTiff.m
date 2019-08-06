function [outp] = readTiff(file)
    inp = Tiff(file);
    nb_frames = size(imfinfo(file),1);
    
    outp = zeros([inp.getTag('ImageLength') inp.getTag('ImageWidth') nb_frames]);
    
    for i = 1:nb_frames
        inp.setDirectory(i);
        outp(:,:,i) = inp.read();
    end
    
end

