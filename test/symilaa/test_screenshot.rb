gem 'minitest'
require 'minitest/autorun'
require_relative '../../lib/symilaa/image'

module Symilaa
  class TestImage < Minitest::Unit::TestCase
    def test_equality_when_images_altered
      one = Image.new grylls
      two = Image.new grylls_different

      refute one == two
    end

    def test_equality_when_images_similar
      one = Image.new grylls
      two = Image.new grylls_slightly_different

      refute one == two
    end

    def test_equality_when_identical
      one = Image.new grylls
      two = Image.new grylls

      assert one == two
    end

    def test_similar_when_identical
      one = Image.new grylls
      two = Image.new grylls

      assert one.similar_to? two
    end
    
    def test_similar_when_similar
      one = Image.new grylls
      two = Image.new grylls_slightly_different

      assert one.similar_to? two
    end
   
    def test_different_sized_images_are_different
      one = Image.new grylls
      two = Image.new the_queen

      refute one.similar_to? two
      refute one == two
    end

    def test_css_font_size_change
      ref  = Image.new fixture 'diagnostics/reference/font_size.png'
      diff = Image.new fixture 'diagnostics/generated/font_size.png'

      refute ref == diff
      refute ref.similar_to? diff
    end

    def test_css_change_of_gradient
      ref  = Image.new fixture 'diagnostics/reference/gradient.png'
      diff = Image.new fixture 'diagnostics/generated/gradient.png'

      refute ref == diff, "Images with different gradients should not be the same"
      refute ref.similar_to?(diff), "Images with different gradients should not be similar"
    end

    def test_lightbox_difference
      ref  = Image.new fixture 'diagnostics/reference/lightbox.png'
      diff = Image.new fixture 'diagnostics/generated/lightbox.png'

      refute ref == diff, "Internet Explorer's rendering of a lightbox is different every time"
      assert ref.similar_to?(diff), "Internet Explorer's rendering of a lightbox is similar enough each time"
    end

    def test_rounded_corners_in_ie9
      ref  = Image.new fixture 'diagnostics/reference/rounded_corner_ie9.png'
      diff = Image.new fixture 'diagnostics/generated/rounded_corner_ie9.png'

      refute ref == diff
      assert ref.similar_to?(diff)
    end

    def test_active_input_state_in_ie9
      ref  = Image.new fixture 'diagnostics/reference/active_input_ie9.png'
      diff = Image.new fixture 'diagnostics/generated/active_input_ie9.png'

      refute ref == diff
      assert ref.similar_to?(diff)
    end

    private

    def fixture name
      File.expand_path "../fixtures/#{name}", File.dirname(__FILE__)
    end
    
    def grylls
      fixture 'bear_grylls.png'
    end

    def grylls_different
      fixture 'bear_grylls_different.png'
    end

    def grylls_slightly_different
      fixture 'bear_grylls_slightly_different.png'
    end

    def the_queen
      fixture 'farewells.jpg'
    end
  end
end
