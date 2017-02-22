%%%%%%%
%Compute the motion vector between each current block and its best
%predicted block
%
%
%%%%%%%

function [MVy MVx] = FullSearch(Block, img_ref, xc, yc, SearchRange)


[M N]       = size(img_ref);
BlockSize   = size(Block,1);
L           = floor(BlockSize/2);
BlockRange  = -L:L-1;
SADmin      = 1e9;


for i = -SearchRange:SearchRange
    for j = -SearchRange:SearchRange
        xt = xc + j;
        yt = yc + i;
        if (xt-L>0)&&(xt+L-1<N+1)&&(yt-L>0)&&(yt+L-1<M+1)
        
            Block_ref  = img_ref(yt+BlockRange, xt+BlockRange);
            SAD = sum(abs(Block(:) - Block_ref(:)));
            
            if SAD < SADmin
            SADmin  = SAD;
            x_min   = xt;
            y_min   = yt;
            i_min   = abs(i);
            j_min   = abs(j);
            
            elseif SAD == SADmin
                if abs(i)+abs(j) < i_min+j_min  
                       SADmin  = SAD;
                       x_min   = xt;
                       y_min   = yt;
                       i_min   = abs(i);
                       j_min   = abs(j);
                       
                elseif abs(i)+abs(j) == i_min+j_min
                    if abs(i) < i_min
                            SADmin  = SAD;
                            x_min   = xt;
                            y_min   = yt;
                            i_min   = abs(i);
                            j_min   = abs(j);
                            
                    elseif abs(i) == i_min
                        if abs(j) <= j_min
                            SADmin  = SAD;
                            x_min   = xt;
                            y_min   = yt;
                            
                            i_min   = abs(i);
                            j_min   = abs(j);
                            
                        end
    
                    end
                end
    
                    
            end
        
         % Motion Vector (integer part)
            MVx = xc - x_min;
            MVy = yc - y_min;
        end
  
     end
end




end



