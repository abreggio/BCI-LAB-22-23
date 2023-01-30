%      This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>. 

% arguments:
% matrix should be of the following shape (number of observations, (features))

% NOTE: useful link: https://jaketae.github.io/study/fisher/

% for simplicity, I will implement fisher score for just two dimensions
% but theoretically it can and should be generalised for n dimensional
% cases

function fisher_score_matrix = get_fisher_score(matrix)

    [sz1, sz2] = size(matrix, 2, 3);
    fisher_score_matrix = zeros(sz1, sz2);

    for i = 1:numel(fisher_score_matrix)
        
        index_row = floor(i / sz1) + 1;
        index_column = mod(i - 1, sz2) + 1;
        
        
        mean_row = mean(matrix(:, index_row, :), 'all');
        mean_column = mean(matrix(:,:,index_column), 'all');

        variance_row = var(matrix(:, index_row, :), 0, 'all');
        variance_column = var(matrix(:, :, index_column), 0, 'all');
        

        fisher_score_matrix(index_row, index_column) = abs(mean_row - mean_column) / sqrt(variance_column + variance_row);
    
    end

end