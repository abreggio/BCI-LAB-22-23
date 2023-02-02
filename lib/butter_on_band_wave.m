%      This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>. 

% applies a butterworth filering to body
% - if no filter order is specified default to 5th order

% inputs: 
% bandwave [1x1 str]: 'mu' or ' beta'
% body [samples x channels double]
% SampleRate [1x1 int]
% order(opt) [1x1 int]: Butterworth filter's order

% return: sfilt [samples x channels]: filtered one-by-one of body channels 

function sfilt = butter_on_band_wave(bandwave, body, SampleRate,ord)
    band = [];
    switch bandwave
        case 'mu'
            band = [8 12]; % [Hz]
        case 'beta'
            band = [18 22]; % [Hz]
        otherwise
            trow(MException('no such argument', 'argument bandwave invalid'))
    end
    
    % default 5th order butterworth filter
    if nargin<4
        ord=5;
    end

    sfilt = zeros(size(body));
    
    [b,a]=butter(ord,band./(SampleRate/2));

    for i = 1:size(body,2)
        sfilt(:,i)=filtfilt(b,a,body(:,i));
    end
    
end