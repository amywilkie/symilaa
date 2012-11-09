gem 'minitest'
require 'minitest/autorun'
require_relative '../../lib/symilaa/screenshot'

module Symilaa
  class TestScreenshot < Minitest::Unit::TestCase
    GRYLLS             = File.expand_path '../fixtures/bear_grylls.png', File.dirname(__FILE__)
    GRYLLS_SLIGHT_DIFF = File.expand_path '../fixtures/bear_grylls_slightly_different.png', File.dirname(__FILE__)
    GRYLLS_DIFF        = File.expand_path '../fixtures/bear_grylls_different.png', File.dirname(__FILE__)
    QUEENY_POPS        = File.expand_path '../fixtures/farewells.jpg', File.dirname(__FILE__)
    FONT_SIZE_REF      = File.expand_path '../fixtures/diagnostics/reference/font_size.png', File.dirname(__FILE__)
    FONT_SIZE_DIFF     = File.expand_path '../fixtures/diagnostics/generated/font_size.png', File.dirname(__FILE__)
    GRADIENT_REF       = File.expand_path '../fixtures/diagnostics/reference/gradient.png', File.dirname(__FILE__)
    GRADIENT_DIFF      = File.expand_path '../fixtures/diagnostics/generated/gradient.png', File.dirname(__FILE__)
    LIGHTBOX_REF       = File.expand_path '../fixtures/diagnostics/reference/lightbox.png', File.dirname(__FILE__)
    LIGHTBOX_DIFF      = File.expand_path '../fixtures/diagnostics/generated/lightbox.png', File.dirname(__FILE__)

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
   
    def test_different_sized_images_are_different
      one = Screenshot.new GRYLLS
      two = Screenshot.new QUEENY_POPS

      refute one.similar_to? two
      refute one == two
    end

    def test_font_size_difference
      diff = Screenshot.new FONT_SIZE_DIFF
      ref  = Screenshot.new FONT_SIZE_REF

      refute ref == diff
      refute ref.similar_to? diff
    end

    def test_gradient_difference
      diff = Screenshot.new GRADIENT_DIFF
      ref  = Screenshot.new GRADIENT_REF

      refute ref == diff, "Images with different gradients should not be the same"
      refute ref.similar_to?(diff), "Images with different gradients should not be similar"
    end

    def test_lightbox_difference
      diff = Screenshot.new LIGHTBOX_DIFF
      ref  = Screenshot.new LIGHTBOX_REF

      refute ref == diff, "Internet Explorer's rendering of a lightbox is different every time"
      assert ref.similar_to?(diff), "Internet Explorer's rendering of a lightbox is similar enough each time"
    end
  end
end

