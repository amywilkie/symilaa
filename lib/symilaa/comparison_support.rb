require 'active_support/core_ext'
require 'RMagick'

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
      inc += 1

      new_path = "#{path}#{inc}#{extension}"

      if File.exists?("#{new_path}")
        get_unique_file_name path, extension, inc
      else
        new_path
      end
    end

    def get_file_name path, extension
      "#{path}#{extension}"
    end


    def create_directories directories
      directories.each do |dir|
        FileUtils.mkdir_p File.join(base_dir, dir)
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
      Capybara.ignore_hidden_elements = false
      val = find('title').native.text.parameterize.underscore
      Capybara.ignore_hidden_elements = true
      val
    end

    def same? reference_file, test_file
      reference_screenshot = Image.new reference_file
      generated_screenshot = Image.new test_file

      reference_screenshot.similar_to? generated_screenshot
    end

    def auto_updating_browser?
      %w[chrome firefox safari].include? browser_name
    end

    def version_if_required
      "_#{browser_info.version.gsub('.', '-')}" unless auto_updating_browser? 
    end

    def reference_screenshots
      File.join base_dir, 'reference_screenshots'
    end

    def screenshots_generated_this_run_dir
      File.join base_dir, 'screenshots_generated_this_run'
    end

    def differences_in_screenshots_this_run_dir
      File.join base_dir, 'differences_in_screenshots_this_run'
    end

    def scenario_name
      @gherkin_statement.parameterize.underscore if @gherkin_statement
    end

    def create_screenshot_directory sub_directory
      FileUtils.mkdir_p(File.join screenshots_generated_this_run_dir, sub_directory, scenario_name)
    end

    def create_screenshot_filename sub_directory, unique_filename_required
      file_name = "#{browser_info.browser_name.capitalize.parameterize}#{version_if_required}_#{browser_info.platform.capitalize}_#{title}"
      if unique_filename_required
        get_unique_file_name "#{screenshots_generated_this_run_dir}/#{sub_directory}#{scenario_name}/#{file_name}", '.png'
      else
        get_file_name "#{screenshots_generated_this_run_dir}/#{sub_directory}#{scenario_name}/#{file_name}", '.png'
      end
    end

    def save_screenshot screenshot_path
      page.driver.browser.save_screenshot screenshot_path
    end

    def difference_file_path generated_screenshot_path
      "#{generated_screenshot_path}_difference.gif".gsub('screenshots_generated_this_run', 'differences_in_screenshots_this_run')
    end

    def check_screen_against_reference_shot target_sub_directory, unique_filename_required = true, retries = 1
      create_directories %w[screenshots_generated_this_run differences_in_screenshots_this_run]
      create_screenshot_directory target_sub_directory

      generated_screenshot_path = create_screenshot_filename target_sub_directory, unique_filename_required
      screenshot_name           = File.basename generated_screenshot_path
      reference_path            = File.join reference_screenshots, target_sub_directory, scenario_name, screenshot_name
      difference_file           = difference_file_path generated_screenshot_path

      retries.times do 
        save_screenshot generated_screenshot_path
        break if same? reference_path, generated_screenshot_path
        sleep 1
      end

      unless same? reference_path, generated_screenshot_path
        FileUtils.mkdir_p File.dirname(difference_file)
        produce_gif_showing_the_difference_between reference_path, generated_screenshot_path, difference_file

        fail "Some of the screenshots did not match"
      end
    end
  end
end
