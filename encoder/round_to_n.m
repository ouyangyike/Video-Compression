%%%%%%%
%Compute the approximated residual
%
%
%%%%%%%
function round_n = round_to_n( input,n )
round_n = round(input/pow2(n))*pow2(n);
end
