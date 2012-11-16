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
