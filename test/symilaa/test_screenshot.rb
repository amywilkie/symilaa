gem 'minitest'
require 'minitest/autorun'
require_relative '../../lib/symilaa/screenshot'

module Symilaa
  class TestScreenshot < Minitest::Unit::TestCase
    def test_equality_when_images_altered
      one = Screenshot.new fixture 'bear_grylls.png'
      two = Screenshot.new fixture 'bear_grylls_different.png'

      refute one == two
    end

    def test_equality_when_images_similar
      one = Screenshot.new fixture 'bear_grylls.png'
      two = Screenshot.new fixture 'bear_grylls_slightly_different.png'

      refute one == two
    end

    def test_equality_when_identical
      one = Screenshot.new fixture 'bear_grylls.png'
      two = Screenshot.new fixture 'bear_grylls.png'

      assert one == two
    end

    def test_similar_when_identical
      one = Screenshot.new fixture 'bear_grylls.png'
      two = Screenshot.new fixture 'bear_grylls.png'

      assert one.similar_to? two
    end
    
    def test_similar_when_similar
      one = Screenshot.new fixture 'bear_grylls.png'
      two = Screenshot.new fixture 'bear_grylls_slightly_different.png'

      assert one.similar_to? two
    end
   
    def test_different_sized_images_are_different
      one = Screenshot.new fixture 'bear_grylls.png'
      two = Screenshot.new fixture 'farewells.jpg'

      refute one.similar_to? two
      refute one == two
    end

    def test_font_size_difference
      ref  = Screenshot.new fixture 'diagnostics/reference/font_size.png'
      diff = Screenshot.new fixture 'diagnostics/generated/font_size.png'

      refute ref == diff
      refute ref.similar_to? diff
    end

    def test_gradient_difference
      ref  = Screenshot.new fixture 'diagnostics/reference/gradient.png'
      diff = Screenshot.new fixture 'diagnostics/generated/gradient.png'

      refute ref == diff, "Images with different gradients should not be the same"
      refute ref.similar_to?(diff), "Images with different gradients should not be similar"
    end

    def test_lightbox_difference
      ref  = Screenshot.new fixture 'diagnostics/reference/lightbox.png'
      diff = Screenshot.new fixture 'diagnostics/generated/lightbox.png'

      refute ref == diff, "Internet Explorer's rendering of a lightbox is different every time"
      assert ref.similar_to?(diff), "Internet Explorer's rendering of a lightbox is similar enough each time"
    end

    private

    def fixture name
      File.expand_path "../fixtures/#{name}", File.dirname(__FILE__)
    end
  end
end
