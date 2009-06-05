require 'test_helper'

class BrowsableTest < ActiveSupport::TestCase
  context "with three beans" do
    
    setup do
      @first = Bean.find 1
      @second = Bean.find 2
      @third = Bean.find 3
    end
  
    context "the first bean" do
    
      should "have the second as next bean" do
        assert_equal @first.next, @second
      end
      
      should "have no previous bean" do
        assert_nil @first.prev
      end
      
    end

    context "the second bean" do
    
      should "have the first as prev bean" do
        assert_equal @second.prev, @first
      end

      should "have the third as next bean" do
        assert_equal @second.next, @third
      end
      
    end

    context "the third bean" do
    
      should "have the second as prev bean" do
        assert_equal @third.prev, @second
      end
      
      should "have no next bean" do
        assert_nil @third.next
      end
      
    end
    
  end
end
