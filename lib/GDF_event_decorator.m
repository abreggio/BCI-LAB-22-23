%     This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

classdef GDF_event_decorator
    properties
        event_header
    end
    methods
        
        function this = GDF_event_decorator(event_header)
                this.event_header = event_header;
        end
        

        function new = plus(this, other)
            if this.event_header.SampleRate ~= other.event_header.SampleRate
                ME = MException('different samplerate', 'cant add headers with different sample rate');
                throw(ME)
            end
            header.POS = [];
            header.TYP = [];
            header.DUR = [];
            header.CHN = [];
            header.SampleRate = other.event_header.SampleRate;
            header.POS = cat(1, this.event_header.POS, other.event_header.POS + this.event_header.FILE.SIZE);
            header.TYP = cat(1, this.event_header.TYP, other.event_header.TYP);
            header.DUR = cat(1, this.event_header.DUR, other.event_header.DUR);
            header.CHN = cat(1, this.event_header.CHN, other.event_header.CHN);
            new = GDF_event_decorator(header);
        end
        function r = get_pos_for(obj, event_type)
            r = obj.event_header.POS(obj.event_header.TYP == event_type);
        end

        function r = get_pos_for_fixation(obj)
            r = obj.get_pos_for(786);
        end
        function r = get_pos_for_cue(obj)
            r = obj.event_header.POS(obj.event_header.TYP == 771 | obj.event_header.TYP == 773 | obj.event_header.TYP == 783);
        end
        function r = get_pos_for_continuous_feedback(obj)
            r = obj.get_pos_for(781);
        end
        function r = get_pos_for_start(obj)
            r = obj.get_pos_for(1);
        end
        function r = get_pos_for_hit(obj)
            r = obj.get_pos_for(897);
        end
        function r = get_dur(obj)
            r = obj.event_header.DUR;
        end

        function r = get_dur_for(obj,event_type)
            r= obj.event_header.DUR(obj.event_header.TYP == event_type);
        end

        function r = get_dur_for_continuous_feedback(obj)
            r= obj.get_dur_for(781);
        end

        function r = get_dur_for_cue(obj)
            r = cat(1, obj.get_dur_for(773), obj.get_dur_for(771));
        end
        
        function r = get_typ(obj)
            r = obj.event_header.TYP;
        end
        function r = get_pos(obj)
            r = obj.event_header.POS;
        end
        function r = get_chn(obj)
            r = obj.event_header.CHN;
        end
        function r = index_event(obj, event)     
            r = obj.event_header.TYP == event;
        end

     
    end
end