%     This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

classdef GDF_event_decorator
    properties
        event_header
        file_size
    end

    methods

        % init 
        function this = GDF_event_decorator(header)
            this.event_header = header.EVENT;
            this.file_size = header.FILE.POS;
        end

        % concatenate different headers with '+' operation
        function new = plus(this,other)
            if this.event_header.SampleRate ~= other.event_header.SampleRate
                ME = MException('different samplerate', 'cant add headers with different sample rate');
                throw(ME)
            end
            header.EVENT.POS = [];
            header.EVENT.TYP = [];
            header.EVENT.DUR = [];
            header.EVENT.CHN = [];
            header.EVENT.SampleRate = other.event_header.SampleRate;
            header.EVENT.POS = cat(1, this.event_header.POS, other.event_header.POS + this.file_size);
            header.EVENT.TYP = cat(1, this.event_header.TYP, other.event_header.TYP);
            header.EVENT.DUR = cat(1, this.event_header.DUR, other.event_header.DUR);
            header.EVENT.CHN = cat(1, this.event_header.CHN, other.event_header.CHN);
            header.FILE.POS = this.file_size + other.file_size;
            new = GDF_event_decorator(header);
        end

        % FUNDAMENTALS FUCNTIONS

        % return Sample Rate
        function SR = get_SR(obj)
            SR = obj.event_header.SampleRate;
        end

        % return POS
        function POS = get_pos(obj)
            POS = obj.event_header.POS;
        end
        
        % return DUR
        function DUR = get_dur(obj)
            DUR = obj.event_header.DUR;
        end

        % return TYP
        function TYP = get_typ(obj)
            TYP = obj.event_header.TYP;
        end

        % return indeces of specified event
        function r = index_event(obj, event)     
            r = find(obj.event_header.TYP == event);
        end

        % return POS of TYP == event
        function r = get_pos_for(obj, event_type)
            r= obj.event_header.POS(obj.event_header.TYP == event_type);
        end

        % return DUR of TYP == event
        function r=get_dur_for(obj, event_type)
            r= obj.event_header.DUR(obj.event_header.TYP == event_type);
        end

        % return TYP of TYP == [<events>] 
        function r = get_typ_for(obj, events)
            flag = zeros(length(obj.event_header.TYP),1,'logical');
            for i=1:length(events)
                event = events(i);
                flag = flag|obj.event_header.TYP == event;
            end
            r = obj.event_header.TYP(flag); 
        end
        

        % UTILITY FUNCTIONS

        % get position 
        function r = get_pos_for_start(obj)
            r = obj.get_pos_for(1);
        end

        % get positions and labels of CUES : 771 (both feet) - 773 (both hands) - 783 (rest)
        function [CuePOS,CueTYP] = get_cues(obj)
            % + r [2 x NumCues]
            % |- r{1} : position of every cues
            % |- r{2} : cues ID 
            % (duration not informative)

            CuePOS= obj.event_header.POS(obj.event_header.TYP == 771 | obj.event_header.TYP == 773 | obj.event_header.TYP == 783);
            CueTYP= obj.get_typ_for([771,773,783]);
        end
        
        % get positions of continuous feedback start
        function r = get_pos_for_continuous_feedback(obj)
            r = obj.get_pos_for(781);
        end

        % get duration of continuous feedback
        function r = get_dur_for_continuous_feedback(obj)
            r = obj.get_dur_for(781);
        end
        
        % get position for hit/miss occurances
        function r = get_pos_for_hit(obj)
            r = obj.get_pos_for(897);
        end

        % get position for cross apprearances
        function r = get_pos_for_fixation(obj)
            r = obj.get_pos_for(786);
        end

        % get duration for cross fixation
        function r = get_dur_for_fixation(obj)
            r = obj.get_dur_for(786);
        end

    end % methods
end %class
