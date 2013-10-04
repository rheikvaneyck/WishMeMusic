# This lib containts the database model
#--
# Copyright (c) 2013 Viktor Rzesanke
# Licensed under the same terms as Ruby. No warranty is provided.

module DiscJockey
  class DJScore
    attr_accessor :dj, :score
    def initialize(dj, score)
      @dj = dj
      @score = score
    end
  end

  class MatchScore
    attr_reader :djs_match, :djs_excluded, :max_score
    attr_accessor :wish_scale, :dj_scale

    def initialize(wish, djs)
      @wish = wish
      @djs = djs
      @djs_match = []
      @djs_excluded = []
      @max_score = nil
    end

    def score(wish_scale = [], dj_scale = [])
      if wish_scale.empty? then
        @wish_scale = ["Lieber nicht", "Geht so", "Ist OK", "Passt Super"]
      else
        @wish_scale = wish_scale
      end
      if dj_scale.empty? then
        @dj_scale = ["NoGo", "Nix", "Mittel", "Viel"]
      else
        @dj_scale = dj_scale
      end

      @djs.each do |dj|
        if dj.aka_dj_name.nil? then dj.aka_dj_name = dj.name end
        # FIXME: random scoring!!! Make a lib for that task
        favour = dj.wishes.first
        score = 0
        exclude_flag = false

        idx = favour.background_musik.index(@wish.background_musik)
        # Wenn der Hintergrundwunsch in den Angeboten des DJ gefunden wird der Index im 
        # String zurückgegeben. Mit dem kann der Substring per regeulären Ausdruck danach 
        # untersucht werden, wie gut das Angebot vom DJ ist. 
        # z.B.
        # @wish.background_musik = "Cafe del Mar"
        # @favour.background_musik = "Bar Jazz: Mittel;Cafe del Mar: Viel;Chanson: Nix;Klassik: Nix;Kuba: Mittel;Lounge: Mittel;Aktuelles: Viel"
        # --> idx = 17
        # favour.background_musik[idx..-1][/^([\w\s]+:)\s*([\w\s]+)/] --> "Viel"
        # $2 steht für den Treffer in der zweiten Klammer, also ist 
        # dj_scale.index($2) --> 2
        unless idx.nil?
          favour.background_musik[idx..-1][/^([\w\s\/-]+:)\s*([\w\s]+)/]
          score = score + @dj_scale.index($2) unless @dj_scale.index($2).nil?
          # Falls der Index 0 ist, wird jedoch das exclude_flag gesetzt:
          exclude_flag = true if @dj_scale.index($2) == 0
        end



        wish_genre = @wish.tanzmusik_genre.split(";").map {|i| i.split(":")}
        #puts wish_genre[0].inspect
        wish_genre.each do |w|
          idx = favour.tanzmusik_genre.index(w[0])
          unless idx.nil?
            favour.tanzmusik_genre[idx..-1][/^([öä\w\s\/-]+:)\s*([\w\s]+)/]
            h_idx = @dj_scale.index($2).nil? ? 0 : @dj_scale.index($2)
            l_idx = @wish_scale.index(w[1].strip)
            score = score + 2 - (h_idx - l_idx).abs
            # set exclude flag if 
            # dj_scale[index] == "NoGo" AND wish_scale[index] <> "Lieber nicht"
            exclude_flag = true if h_idx == 0 and l_idx > 0
          end
        end

        wish_zeit = @wish.tanzmusik_zeit.split(";").map {|i| i.split(":")}
        # puts wish_zeit[0].inspect
        wish_zeit.each do |w|
          idx = favour.tanzmusik_zeit.index(w[0])
          unless idx.nil?
            favour.tanzmusik_zeit[idx..-1][/^([öä\w\s\/-]+:)\s*([\w\s]+)/]
            h_idx = @dj_scale.index($2).nil? ? 0 : @dj_scale.index($2)
            l_idx = @wish_scale.index(w[1].strip)
            score = score + 2 - (h_idx - l_idx).abs
            # set exclude flag if 
            # dj_scale[index] == "NoGo" AND wish_scale[index] <> "Lieber nicht"
            exclude_flag = true if h_idx == 0 and l_idx > 0
          end
        end
        
        @djs_match << DJScore.new(dj.aka_dj_name, score) unless exclude_flag
        @djs_excluded << dj.aka_dj_name if exclude_flag
      end
      @djs_match.sort! {|x,y| x.score <=> y.score}.reverse!
      @max_score = @djs_match.max { |x,y| x.score <=> y.score}    
    end

  end
end