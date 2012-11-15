module Symilaa
  module ComparisonSupport
    def add_text_to_image text, image
      txt = Draw.new
      image.annotate(txt, 0, 0, 0, 50, text) {
        txt.gravity = Magick::SouthGravity
        txt.pointsize = 25
        txt.stroke = '#ff0000'
        txt.fill = '#ff0000'
        txt.font_weight = Magick::BoldWeight
      }
    end

    def produce_gif_showing_the_difference_between reference_shot, test_shot, output_file
      gif = Magick::ImageList.new(reference_shot, test_shot)
      add_text_to_image "Test Screenshot", gif[1]
      gif.delay = 100
      gif.write(output_file)
    end

    def get_unique_file_name path, extension, inc
      inc = 0 unless inc
      inc = inc.to_int+1

      new_path = "#{path}#{inc}#{extension}"

      if File.exists?("#{new_path}")
        get_unique_file_name path, extension, inc
      else
        new_path
      end
    end

    def check_screen_against_reference_shot sub_directory
      sub_directory = "#{sub_directory}#{@gherkin_statement.parameterize.underscore}/"

      FileUtils.mkdir_p("#{SCREENSHOTS_GENERATED_THIS_RUN_DIR}/#{sub_directory}")

      browser_info = page.driver.browser.capabilities

      version_if_required = "_#{browser_info.version.gsub('.', '-')}" unless browser_info.browser_name == 'firefox' and browser_info.version != '3.5' or browser_info.browser_name == 'chrome'

      title = find('title').text
      file_name = "#{browser_info.browser_name.capitalize.parameterize}#{version_if_required}_#{browser_info.platform.capitalize}_#{title.parameterize.underscore}"
      test_file = get_unique_file_name "#{SCREENSHOTS_GENERATED_THIS_RUN_DIR}/#{sub_directory}#{file_name}", '.png', nil

      page.driver.browser.save_screenshot test_file

      screenshot_name = File.basename test_file
      reference_file = "#{REFERENCE_SCREENSHOTS}/#{sub_directory}#{screenshot_name}"

      reference_screenshot = Image.new reference_file
      generated_screenshot = Image.new test_file

      same = if dodgy_browser?
               reference_screenshot.similar_to? generated_screenshot
             else
               reference_screenshot == generated_screenshot
             end

      unless same
        FileUtils.mkdir_p("#{DIFFERENCES_IN_SCREENSHOTS_THIS_RUN_DIR}/#{sub_directory}")
        produce_gif_showing_the_difference_between(reference_file, test_file, "#{DIFFERENCES_IN_SCREENSHOTS_THIS_RUN_DIR}/#{sub_directory}#{screenshot_name}_difference.gif")
        fail "Some of the screenshots did not match"
      end
    end

    def dodgy_browser?
      %w[chrome ie7 ie8 ie9].include? ENV['REQUIRED_BROWSER']
    end
  end
end
