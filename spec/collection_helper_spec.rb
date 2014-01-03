require File.join(File.dirname(__FILE__),'..','helpers','collection_helper')

class CollectionPropTester
        include CollectionHelper
end

describe CollectionPropTester do

        before(:all) do
          class R 
            attr_accessor :min, :max, :main
            def initialize(min, max, main)
              @min = min
              @max = max
              @main = main
            end
          end
          @coll = [R.new(0,100,50), R.new(0,10,5), R.new(20,40,30)]
        end

        it "extracts only valid strings for names from input" do
                expect(collection_item_prop_include?(@coll, :min, 20)).to be_true
        end
end
