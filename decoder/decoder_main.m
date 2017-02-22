

nFrames = 300;     %# The number of frames
vidHeight = 288;   %# The image height
vidWidth = 352;    %# The image width
block_size = 8;

size_y_frame = vidHeight * vidWidth;
MV = 'MV.txt';
residual = 'residual.txt';

fid = fopen('Y_only_decoded.yuv','a');
for frame_num = 0: 1: 9
    if frame_num == 0
        lastframe = ones(vidHeight,vidWidth)*128;
        if mod(vidWidth,block_size) ~= 0
        Y = padarray(Y,[0 block_size-mod(vidWidth,block_size)],128,'post');
        end
        if mod(vidHeight,block_size) ~= 0
            Y = padarray(Y,[block_size-mod(vidHeight,block_size) 0],128,'post');
        end
    else
        lastframe = predicted;
    end
    predicted = decoder(vidHeight, vidWidth, block_size, lastframe, MV, residual,frame_num);
    
    predicted_new = predicted(1:vidHeight, 1:vidWidth).';
    fseek(fid, (frame_num - 1) * size_y_frame, 'bof');
    fwrite(fid, predicted_new); 
  
 end

fclose(fid);