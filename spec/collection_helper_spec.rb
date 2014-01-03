require File.join(File.dirname(__FILE__),'..','helpers','collection_helper')

class CollectionPropTester
        include CollectionHelper
end

describe CollectionPropTester do

        before(:all) do
          class C 
            attr_accessor :category, :value, :score
            def initialize(category, value, score)
              @min = category
              @max = value
              @main = score
            end
          end
          @categories = [C.new("wish","Viel",3), C.new("wish","Mittel",2), C.new("wish","Wenig", 1)]
          
          class M 
            attr_accessor :category, :name, :description
            def initialize(category, name, description)
              @min = category
              @max = name
              @main = description
            end
          end
          @music = [
                  M.new("tanzmusik_genre","Aktuelle Charts",3),
                  M.new("tanzmusik_genre","POP International",2), 
                  M.new("tanzmusik_genre","POP Deutsch", 1)
                  ]
        end

        it "checks if categories collection includes 'Mittel'" do
                expect(collection_item_prop_include?(@categories, :value, "Mittel")).to be_true
        end
        
        it "checks if music collection includes 'Aktuelle Charts'" do
                expect(collection_item_prop_include?(@music, :name, "Aktuelle Charts")).to be_true
        end
end
