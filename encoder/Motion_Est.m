function [motion_vectory motion_vectorx]= Motion_Est( file_name, file_ref_name, height, width, frame, block_size,Search_range, frame_num, roundtoN)
%%%%%%%
%Compute the motion vector using the reconstured block
%
%
%
%%%%%%%

   
% read the YUV 
file = fopen(file_name, 'r');

% the size of each frame

size_frame = width * height * 1.5;
size_y_frame = width * height;

% the number of frame

num_frame = length(frame);

if frame_num == 0
    Y=ones(height,width)*128;
else
    
	% read Y from reference frame and reshape 
    
    file_ref = fopen(file_ref_name, 'r');
    fseek(file_ref, (frame_num - 1) * size_y_frame, 'bof');
    data1  = fread(file_ref, width * height, 'uchar');
    fclose(file_ref);
	Y = reshape(data1, width, height).';
    
end
    block_num_w = ceil(width/block_size);
	block_num_h = ceil(height/block_size);
     
    img_show(:,:,1) = Y;
    subplot(1,3,1);
    imshow(img_show/255);
    
	if mod(width,block_size) ~= 0
        Y = padarray(Y,[0 block_size-mod(width,block_size)],128,'post');
    end
    if mod(height,block_size) ~= 0
        Y = padarray(Y,[block_size-mod(height,block_size) 0],128,'post');
    end
   
    
   fseek(file, size_frame * frame_num, 'bof');
	data2 = fread(file, width * height, 'uchar');
    fclose(file);
    Z = reshape(data2, width, height).';
         
    subplot(1,3,2);
    imshow(Z/255);
    
	if mod(width,block_size) ~= 0
        Z = padarray(Z,[0 block_size-mod(width,block_size)],128,'post');
    end
    if mod(height,block_size) ~= 0
        Z = padarray(Z,[block_size-mod(height,block_size) 0],128,'post');
    end

	coordinate_w = 1: block_size: block_size*(block_num_w-1)+1;
	coordinate_h = 1: block_size: block_size*(block_num_h-1)+1;

        block_range = 0: block_size-1;
        m = 1;
        n = 1;
 	for m = 1: 1: block_num_h
 		for n = 1: 1: block_num_w
		    [motion_vectory1,motion_vectorx1] = FullSearch(Z(coordinate_h(m)+block_range, coordinate_w(n)+block_range),Y,coordinate_w(n)+block_size/2,coordinate_h(m)+block_size/2,Search_range);
            [block_predict residual] = Block_residual(Z(coordinate_h(m)+block_range, coordinate_w(n)+block_range), Y, coordinate_w(n)+block_size/2,coordinate_h(m)+block_size/2, motion_vectorx1, motion_vectory1,roundtoN);
            block_construct(coordinate_h(m)+block_range, coordinate_w(n)+block_range) = block_predict + residual;
            motion_vectory(m,n) = motion_vectory1;
            motion_vectorx(m,n) = motion_vectorx1;
 		end
    end
     
    block_construct = block_construct(1:height, 1:width);
    subplot(1,3,3);
    imshow(block_construct/255);
    block_construct = block_construct.';
    
    fid = fopen(file_ref_name,'a');
    fseek(fid, (frame_num - 1) * size_y_frame, 'bof');
    fwrite(fid,block_construct);
    fclose(fid);

	


