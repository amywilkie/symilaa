require 'RMagick'
require 'fileutils'

module Symilaa
  class Image
    SIMILARITY_THRESHOLD = 42.6

    attr_reader :path

    def initialize path
      @path = path
    end

    def == other
      FileUtils.cmp path, other.path
    end

    def similar_to? other
      this_one = Magick::Image.read(@path).first
      that_one = Magick::Image.read(other.path).first

      similiarity_factor = this_one.compare_channel(that_one, Magick::PeakSignalToNoiseRatioMetric)[1]

      similiarity_factor >= SIMILARITY_THRESHOLD
    rescue Magick::ImageMagickError; end
  end
end
