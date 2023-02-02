%      This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>. 

function ch=make_channel_map()
ch= struct();
ch.Fz = 1;
ch.FC3= 2; 
ch.FC1= 3;
ch.FCz= 4;
ch.FC2= 5;
ch.FC4= 6;
ch.C3 = 7;
ch.C1 = 8;
ch.Cz = 9;
ch.C2 = 10;
ch.C4 = 11;
ch.CP3= 12;
ch.CP1= 13;
ch.Cpz= 14;
ch.Cp2= 15;
ch.Cp4= 16;

% to get label vect: fieldnames(ch)
% will return: [{'Fz'},{'FC3'},...]