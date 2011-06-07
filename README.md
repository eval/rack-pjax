Rack-pjax [![stillmaintained](http://stillmaintained.com/eval/rack-pjax.png)](http://stillmaintained.com/eval/rack-pjax)
========

Rack-pjax is middleware that lets you serve 'chrome-less' pages in respond to [pjax-requests](https://github.com/defunkt/jquery-pjax).

While responding to a pjax-request is quite easy on a per application basis (e.g. just skip the layout), there are less optimal situations. 
For example when you have:
- a rack stack, consisting of separate pieces of middleware
- an application you can't or don't want to customize (e.g. Spree, Radiant)


Usage
------------

I. Include **rack-pjax** as middleware to your application(-stack)

```ruby
    # config.ru
    require ::File.expand_path('../config/environment',  __FILE__)
    use Rack::Pjax
    run RackApp::Application
```
II. Install [jquery-pjax](https://github.com/defunkt/jquery-pjax). Make sure to add the 'data-pjax-container'-attribute to the container.

```html
    <head>
      ...
      <script src="/javascripts/jquery.js"></script>
      <script src="/javascripts/jquery.pjax.js"></script>
      <script type="text/javascript">
        $(function(){
          $('a:not([data-remote]):not([data-behavior]):not([data-skip-pjax])').pjax('[data-pjax-container]')
        })
      </script>
      ...
    </head>
    <body>
      <div data-pjax-container>
        ...
      </div>
    </body>
```

III. Fire up your [pushState-enabled browser](http://caniuse.com/#search=pushstate) and enjoy!


Installation
------------

    $ gem install rack-pjax

Author
------

Gert Goet (eval) :: gert@thinkcreate.nl :: @gertgoet

License
------

(The MIT license)

Copyright (c) 2011 Gert Goet, ThinkCreate

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
