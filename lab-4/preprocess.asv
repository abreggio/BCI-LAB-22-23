%      This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>. 

% find the gdf files in .data
clearvars;

addpath('../lib')

fileList = dir('../data/*.gdf');


% now cycle over them, preprocess and store in a local folder data

mkdir('./data');

load('../data/laplacian16.mat');

for i = 1 : length(fileList)
    
    name = strcat('../data/', fileList(i).name);

    [body, data] = sload(name);
    body = body(:, 1:16) * lap;
    
    wlength = 0.5; 
    pshift = 0.25; 
    wshift = 0.0625; 
    samplerate = data.SampleRate;
    mlength = 1; 
    [PSD, f] = proc_spectrogram(body, wlength, wshift, pshift, samplerate, [, mlength]);

    PSD = PSD(:, 4:48, :);
    

    winconv = 'backward';
    POS = proc_pos2win(data.EVENT.POS, wshift*samplerate, winconv, mlength*samplerate);

    save(strcat('./data/', fileList(i).name, '.mat'), 'PSD', 'POS')
end