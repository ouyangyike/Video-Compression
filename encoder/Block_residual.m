function [Block_predicted block_residual] = Block_residual(Block, img_ref, xc, yc, MVx, MVy, n)

%%%%%%%
%Compute the residual between the predicted block and current block
%
%
%%%%%%%
BlockSize   = size(Block,1);
L           = floor(BlockSize/2);
BlockRange  = -L:L-1;

Block_predicted  = img_ref(yc - MVy+BlockRange, xc - MVx+BlockRange);
block_residual = Block - Block_predicted ;
block_residual = round_to_n(block_residual, n);

fid = fopen('residual.txt','a');
fseek(fid, 0, 1);

fprintf(fid,'%d ',block_residual);
fclose(fid);

end

