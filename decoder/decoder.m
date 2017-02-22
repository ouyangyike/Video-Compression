function predicted = decoder(vidHeight, vidWidth, block_size, lastframe, MV, residual,frame_num)

frame_size = vidHeight*vidWidth;
block_num_w = ceil(vidWidth/block_size);
block_num_h = ceil(vidHeight/block_size);
block_num = block_num_w*block_num_h;

MV = load(MV);
MV = MV(2*block_num*frame_num+1:2*block_num*(frame_num+1));
MVy = MV(1:block_num);
MVy = reshape(MVy, block_num_h, block_num_w);
MVx = MV(block_num+1:2*block_num);
MVx = reshape(MVx, block_num_h, block_num_w);

residual = load(residual);
residual = residual(frame_num*frame_size+1: (frame_num+1)*frame_size);
residual = reshape(residual, vidHeight, vidWidth);

if mod(vidWidth,block_size) ~= 0
    lastframe = padarray(lastframe,[0 block_size-mod(vidWidth,block_size)],128,'post');
end
if mod(vidHeight,block_size) ~= 0
    lastframe = padarray(lastframe,[block_size-mod(vidHeight,block_size) 0],128,'post');
end

coordinate_w = 1: block_size: block_size*(block_num_w-1)+1;
coordinate_h = 1: block_size: block_size*(block_num_h-1)+1;

block_range = 0: block_size-1;
m = 1;
n = 1;
for m = 1: 1: block_num_h
    for n = 1: 1: block_num_w
        
        
        residual_block = residual(1+((m-1) * block_num_w + n -1)*block_size*block_size : ((m-1) * block_num_w + n)*block_size*block_size);
        residual_block = reshape(residual_block,block_size, block_size);
        predicted(coordinate_h(m)+block_range, coordinate_w(n)+block_range) = residual_block + lastframe(coordinate_h(m) - MVy(m,n) + block_range,  coordinate_w(n) - MVx(m,n) + block_range);
        %predicted(coordinate_h(m)+block_range, coordinate_w(n)+block_range) = residual_block + lastframe(coordinate_h(m) + block_range,  coordinate_w(n) + block_range);
end

% imshow(predicted/255);
%imshow((residual+128)/255);
end
    