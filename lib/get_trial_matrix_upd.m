%      This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

% " a trial lasts from the fixation cross to the end of the continuous 
% feedback period) " 
function [trial_matrix, EventLabel] = get_trial_matrix_upd(body, gdf_event_decorator)
    
    nchannels = size(body,2);

    % trial matrix include:cross apprearance + cue appreance + continous feedback
    CFeedbackPOS = gdf_event_decorator.get_pos_for_continuous_feedback();
    CFeedbackDUR = gdf_event_decorator.get_dur_for_continuous_feedback();

    [CuePOS,CueTYP] = gdf_event_decorator.get_cues();

    CrossPOS = gdf_event_decorator.get_pos_for_fixation();
    
    % init
    
    NTrials = length(CFeedbackPOS);
    TrialStart = nan(NTrials, 1);
    TrialStop  = nan(NTrials, 1);
    EventLabel = nan(NTrials,1);

    if length(CueTYP) ~= NTrials
        disp(['Cues: ',num2str(length(CueTYP)),'; Num Trials: ', num2str(NTrials)])
        ME = MException('MATLAB:test', 'number of trials and number of cues expected to be the same');
        throw(ME)
    end

    % find shortest trial   
    
    for i = 1:NTrials
        cstart = CrossPOS(i);
        cstop  = CFeedbackPOS(i) + CFeedbackDUR(i) - 1;        
        TrialStart(i) = cstart;
        TrialStop(i)  = cstop;
        EventLabel(i) = CueTYP(i);
    end
    
    MinTrialDur = min(TrialStop - TrialStart);

    % make trial matrix

    trial_matrix   = nan(MinTrialDur, nchannels, NTrials);

    for i = 1:NTrials
        cstart = TrialStart(i);
        cstop  = cstart + MinTrialDur - 1;
        trial_matrix(:, :, i)   = body(cstart:cstop, :);
    end

end