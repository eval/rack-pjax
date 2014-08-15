Rack-pjax sample-app
====================

This is the sample-app from [jquery-pjax](http://pjax.herokuapp.com/) but with rack-pjax onboard.

Check out [what changes](https://github.com/eval/rack-pjax/compare/7dbe7fa1^...7dbe7fa1) were needed to enable rack-pjax.

In the current version rack-pjax is vendored in the folder vendor/rack-pjax. This way it's easier to look at the source and see how changes to it affect the app.

Running
-------

    $ bundle install
    $ bundle exec shotgun config.ru

