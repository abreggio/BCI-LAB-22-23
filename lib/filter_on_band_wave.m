%      This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>. 

function sfilt = filter_on_band_wave(bandwave, body, SampleRate)
    band = [];
    switch bandwave
        case 'mu'
            band = [10 12];
        case 'beta'
            band = [18 22];
        otherwise
            trow(MException('no such argument', 'argument bandwave invalid'))
    end

    sfilt = zeros(size(body));

    for i = 1:size(body,2)
        sfilt(:, i) = bandpass(body(:, i), band, SampleRate);
    end
end
