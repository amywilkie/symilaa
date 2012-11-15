module Symilaa
  module ComparisonSupport
    def base_dir= dir
      @base_dir = dir
    end

    def base_dir
      @base_dir || 'artifacts'
    end

    def add_text_to_image text, image
      txt = Magick::Draw.new
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

    def get_unique_file_name path, extension, inc=0
      inc = inc.to_int+1

      new_path = "#{path}#{inc}#{extension}"

      if File.exists?("#{new_path}")
        get_unique_file_name path, extension, inc
      else
        new_path
      end
    end

    def create_directories directories
      directories.each do |dir|
        path = File.join base_dir, dir
        FileUtils.rm_rf(path) if File.exists? path
        FileUtils.mkdir_p path
      end
    end

    def browser_info
      @browser_info ||= page.driver.browser.capabilities
    end

    def browser_name
      browser_info.browser_name
    end

    def browser_version
      browser_info.version
    end

    def title
      find('title').text.parameterize.underscore
    end

    def same? reference_file, test_file
      reference_screenshot = Image.new reference_file
      generated_screenshot = Image.new test_file

      if dodgy_browser?
        reference_screenshot.similar_to? generated_screenshot
      else
        reference_screenshot == generated_screenshot
      end
    end

    def dodgy_browser?
      %w[chrome ie7 ie8 ie9].include? ENV['REQUIRED_BROWSER']
    end

    def chrome_or_firefox_3_5
      browser_name == 'chrome' or (browser_name == 'firefox' and browser_version == '3.5')
    end

    def version_if_required
      "_#{browser_info.version.gsub('.', '-')}" if chrome_or_firefox_3_5? 
    end

    def reference_screenshots
      File.join base_dir, 'reference_screenshots'
    end

    def screenshots_generated_this_run_dir
      File.join base_dir, 'screenshots_generated_this_run'
    end

    def scenario_name
      @gherkin_statement.parameterize.underscore if @gherkin_statement
    end

    def create_screenshot_directory sub_directory, scenario_name
      FileUtils.mkdir_p(File.join screenshots_generated_this_run_dir, sub_directory, scenario_name)
    end

    def create_screenshot_filename sub_directory
      file_name = "#{browser_info.browser_name.capitalize.parameterize}#{version_if_required}_#{browser_info.platform.capitalize}_#{title}"
      get_unique_file_name "#{screenshots_generated_this_run_dir}/#{sub_directory}#{file_name}", '.png'
    end

    def save_screenshot screenshot_path
      page.driver.browser.save_screenshot screenshot_path
    end

    def check_screen_against_reference_shot target_sub_directory
      create_directories %w[reference_screenshots screenshots_generated_this_run differences_in_screenshots_this_run]
      create_screenshot_directory target_sub_directory

      generated_screenshot_path = create_screenshot_filename target_sub_directory
      screenshot_name           = File.basename generated_screenshot_path
      reference_path            = File.join reference_screenshots, target_sub_directory, screenshot_name
      difference_file           = File.join path, "#{screenshot_name}_difference.gif"

      save_screenshot generated_screenshot_path

      unless same? reference_path, generated_screenshot_path
        path = File.join differences_in_screenshots_this_run_dir, target_sub_directory
        FileUtils.mkdir_p path

        produce_gif_showing_the_difference_between reference_path, generated_screenshot_path, difference_file

        fail "Some of the screenshots did not match"
      end
    end
  end
end
