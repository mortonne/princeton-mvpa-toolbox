function [pval] = compute_pval_1tailed(actual, nulls)

% Figures out where the actual-goodness value lies relative
% to all the null distribution of shuffled-goodness
% values, giving us a p value.
%
% N.B. This is a one-tailed test (more power).
%
% NULLS = vector of values that make up our null
% distribution (generated by shuffling our labels etc.)


switch afni_isrow(nulls)
 case 1
  % it's a row vector - good. carry on
 case 0
  % convert to a row vector
  nulls = nulls';
 otherwise
  error('NULLS should be a vector')
end

% the size of our null distribution
nNulls = length(nulls);

% sort our row vector so that the biggest values are on
% the left
nulls = sort(nulls, 2, 'descend');

% count how many of the null distribution values are larger than (or
% equal to) our actual value to give us the rank for the actual value,
% e.g. if 4 values are bigger then actual_rank is 5th
actual_rank = sum(nulls>=actual);

% e.g. if you came 7th out of 1000 values, the p value is
% 0.007%
%
% N.B. if you have 1000 values in your null distribution,
% then you need to divide by 1001 to take into account the
% inclusion of the actual value in the list
%
% UPDATE: see
% http://groups.google.com/group/mvpa-toolbox/browse_thread/thread/1059ece7da64e360?pli=1. now
% adds 1 to the ACTUAL_RANK, so that you don't get p=0 if
% the real value is better than all the nulls
pval = (actual_rank+1) / (nNulls+1);


%%%
% two-tailed test
%
% this code excerpted from Joel Quamme's RF_WAVEWRAPPER.M
% gives an idea of how to do a two-tailed test
%
% wavemat = mean(distromat);
%
% for dm = 1:size(distromat,2)
%     distromat(:,dm) = sort(distromat(:,dm));
%     tmpDistPlace = find(distromat(:,dm)>=actualmat(dm));
%     if numel(tmpDistPlace) == 0;
%       st_tailDist = size(distromat,1)+1;
%     else
%       st_tailDist = tmpDistPlace(1);
%     end
%     tmpDistPlace = find(distromat(:,dm)<=actualmat(dm));
%     if numel(tmpDistPlace) == 0;
%       gt_tailDist = [1];
%     else
%       gt_tailDist = (size(distromat,1)+1) - tmpDistPlace(end);
%     end
%     distPlace(dm) = min(st_tailDist, gt_tailDist);
% end
%
% pVals = distPlace ./ (size(distromat,1)+1);
