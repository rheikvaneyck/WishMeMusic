require 'disc_jockey'
Dir[File.join(File.dirname(__FILE__), '..', 'web', 'models', '*.rb')].each do |file| 
  require file 
end

include DiscJockey

describe MatchScore do
  
  before(:all) do
    @db = DBManager.new("spec/test_data")

    @wish = Wish.new(
      :background_musik => "Klassik",
      :tanzmusik_genre => "Aktuelle Charts: Passt Super;POP International: Passt Super;POP Deutsch: Lieber nicht;Rock Oldies: Lieber nicht;Rock Modern: Passt Super;Rock Deutsch: Passt Super;Alternative: Passt Super;Soul/Funk: Lieber nicht;Latino: Lieber nicht;House/Techno: Lieber nicht;Hip Hop International: Lieber nicht;Hip Hop Deutsch: Lieber nicht;World-Musik: Lieber nicht;Kölsches Tön: Lieber nicht;Schlager/NDW: Lieber nicht;Mallorca/Apres-Ski: Lieber nicht;Standard-Tänze: Lieber nicht",
      :tanzmusik_zeit => "20/30/40er Jahre: Lieber nicht;50/60er Jahre: Lieber nicht;70er Jahre: Lieber nicht;80er Jahre: Lieber nicht;90er Jahre: Passt Super;2000 bis heute: Passt Super"
      )
    @djs = User.find(:all, :conditions => [ "role = ?", "dj"])
    
    @ms = MatchScore.new(@wish, @djs)

    dj_scale = ["NoGo", "Nix", "Mittel", "Viel"]
    wish_scale = ["Lieber nicht", "Geht so", "Ist OK", "Passt Super"]

    @ms.score(wish_scale, dj_scale)
  end

  it "should return the list of matching DJs" do
    expect(@ms.djs_match.last.dj).to eq("DJ James")
  end

  it "should return best match score" do
    # The Tests:key => "value", 
    expect(@ms.max_score.score).to eq(15)
  end

  it "should return DJ name for max score" do
    expect(@ms.max_score.dj).to eq("DJ Jean")
  end

  it "should return DJs with a NoGo for a demanded kind of music" do
    expect(@ms.djs_excluded).to include("DJ John")
  end

end