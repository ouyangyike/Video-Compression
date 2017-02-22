
nFrames = 300;     %# The number of frames
vidHeight = 288;   %# The image height
vidWidth = 352;    %# The image width
block_size = 8;    %# The block size i
Search_range = 4; %# The search range r
frame_num = 0;     %# The beginning frame number
roundtoN = 3;      %# The parameter n on residual approximation


 fid = fopen('MV.txt','a');
 fseek(fid, 0 , 1);
for frame_num = 0: 1: 9
[vectory,vectorx]=Motion_Est( 'foreman_cif.yuv', 'Y_only_reconstructed.yuv' ,vidHeight,vidWidth,1:nFrames,block_size, Search_range, frame_num, roundtoN);
%    subplot(1,3,3);
%  quiver(vectorx(end:-1:1,:), vectory(end:-1:1,:));
 
  fprintf(fid,'%d ',vectory);
  fprintf(fid,'%d ',vectorx);

end
   fclose(fid);