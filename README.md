Hello.

Sometimes it is nice to compare two images with one another.  We find this
particularly handy for testing browser screenshots.

With Symilaa, this is particularly easy.

1. How to do it.
----------------

```ruby
one = Symilaa::Image.new 'image.png'
two = Symilaa::Image.new 'slightly_different_image.png'
three = Symilaa::Image.new 'very_different_image.png'

one == one
#=> true
one == two
#=> false
one.similar_to? two
#=> true
one.similar_to? three
#=> false
```
That's it.  Have a nice life.

-------------------------

`ComparisonSupport` also provides a module for use with Cucumber testing.

Use `ComparisonSupport#check_screen_against_reference_shot` to take a screenshot of the current page under test
and compare it with an existing reference screenshot.

## NOTE
You must include the following in your features/support/env.rb:
```ruby
Before do |scenario|
  @gherkin_statement = scenario.gherkin_statement.name if scenario.respond_to?('gherkin_statement')
  @gherkin_statement = scenario.scenario_outline.gherkin_statement.name if scenario.respond_to?('scenario_outline')
end

FileUtils.rm_rf 'artifacts/screenshots_generated_this_run'
```