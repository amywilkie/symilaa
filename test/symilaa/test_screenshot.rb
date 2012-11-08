gem 'minitest'
require 'minitest/autorun'
require_relative '../../lib/symilaa/screenshot'

module Symilaa
  class TestScreenshot < Minitest::Unit::TestCase
    GRYLLS             = File.expand_path '../fixtures/bear_grylls.png', File.dirname(__FILE__)
    GRYLLS_SLIGHT_DIFF = File.expand_path '../fixtures/bear_grylls_slightly_different.png', File.dirname(__FILE__)
    GRYLLS_DIFF        = File.expand_path '../fixtures/bear_grylls_different.png', File.dirname(__FILE__)

    def test_equality_when_images_altered
      one = Screenshot.new GRYLLS
      two = Screenshot.new GRYLLS_DIFF

      refute one == two
    end

    def test_equality_when_images_similar
      one = Screenshot.new GRYLLS
      two = Screenshot.new GRYLLS_SLIGHT_DIFF

      refute one == two
    end

    def test_equality_when_identical
      one = Screenshot.new GRYLLS
      two = Screenshot.new GRYLLS

      assert one == two
    end

    def test_similar_when_identical
      one = Screenshot.new GRYLLS
      two = Screenshot.new GRYLLS

      assert one.similar_to? two
    end
    
    def test_similar_when_similar
      one = Screenshot.new GRYLLS
      two = Screenshot.new GRYLLS_SLIGHT_DIFF

      assert one.similar_to? two
    end
   
    def test_similar_when_different
      one = Screenshot.new GRYLLS
      two = Screenshot.new GRYLLS_DIFF

      refute one.similar_to? two
    end
  end
end

