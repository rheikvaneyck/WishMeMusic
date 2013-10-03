require 'disc_jockey'
Dir[File.join(File.dirname(__FILE__), '..', 'web', 'models', '*.rb')].each do |file| 
  require file 
end

class MatchScore
end

describe MatchScore do
  it "should return best match score" do
    class DJScore
      attr_accessor :dj, :score
      def initialize(dj, score)
        @dj = dj
        @score = score
      end
    end

    @db = DiscJockey::DBManager.new

#    @wish = DiscJockey::DBManager::Wish.find(:first)
    @wish = Wish.new(
      :background_musik => "Klassik",
      :tanzmusik_genre => "Aktuelle Charts: Passt Super;POP International: Passt Super;POP Deutsch: Lieber nicht;Rock Oldies: Lieber nicht;Rock Modern: Passt Super;Rock Deutsch: Passt Super;Alternative: Passt Super;Soul/Funk: Lieber nicht;Latino: Lieber nicht;House/Techno: Lieber nicht;Hip Hop International: Lieber nicht;Hip Hop Deutsch: Lieber nicht;World-Musik: Lieber nicht;Kölsches Tön: Lieber nicht;Schlager/NDW: Lieber nicht;Mallorca/Apres-Ski: Lieber nicht;Standard-Tänze: Lieber nicht",
      :tanzmusik_zeit => "20/30/40er Jahre: Lieber nicht;50/60er Jahre: Lieber nicht;70er Jahre: Lieber nicht;80er Jahre: Lieber nicht;90er Jahre: Passt Super;2000 bis heute: Passt Super"
      )
    @djs = User.find(:all, :conditions => [ "role = ?", "dj"])

    how_much = ["NoGo", "Nix", "Mittel", "Viel"]
    like_it = ["Lieber nicht", "Geht so", "Ist OK", "Passt Super"]
    @djs_match = []
    @djs_excluded = []
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
      # how_much.index($2) --> 2
      unless idx.nil?
        favour.background_musik[idx..-1][/^([\w\s\/-]+:)\s*([\w\s]+)/]
        score = score + how_much.index($2)
        # Falls der Index 0 ist, wird jedoch das exclude_flag gesetzt:
        exclude_flag = true if how_much.index($2) == 0
      end



      wish_genre = @wish.tanzmusik_genre.split(";").map {|i| i.split(":")}
      #puts wish_genre[0].inspect
      wish_genre.each do |w|
        idx = favour.tanzmusik_genre.index(w[0])
        unless idx.nil?
          favour.tanzmusik_genre[idx..-1][/^([öä\w\s\/-]+:)\s*([\w\s]+)/]
          score = score + 2 - (how_much.index($2) - like_it.index(w[1].strip)).abs
          exclude_flag = true if how_much.index($2) == 0
        end
      end
      
      @djs_match << DJScore.new(dj.aka_dj_name, score) unless exclude_flag
      @djs_excluded << dj.aka_dj_name if exclude_flag
    end
    @djs_match.sort! {|x,y| x.score <=> y.score}.reverse!
    @max_score = @djs_match.max { |x,y| x.score <=> y.score}

    # The Tests:
    @max_score.dj.should == "Risse"
    @max_score.score.should == 11
    @djs_excluded.include?("Koffer Kuli")
    @max_score.score.should > 0
  end
end