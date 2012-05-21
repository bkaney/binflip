Binflip
=======

Simple environmental feature toggling (that works well with Rollout)


Description
===========

Keeping true to twelve-factor application principles <http://12factor.net>, this simple library uses environment variables, with a straightforward naming convention, to specify feature toggles.  

Rollout Compatibility
======================

If Rollout <https://github.com/jamesgolick/rollout> is present, it will pass through most rollout methods except `active?`, where a preliminary test is done to see if the environment toggle is active first.

Rationale
=========

When using a continuous delivery process, it is important to try to get all code integrated into the mainline as soon as possible.  Feature toggles are favored over feature branches (<http://www.infoq.com/interviews/jez-humble-martin-fowler-cd>, <http://martinfowler.com/bliki/FeatureToggle.html>, <http://fournines.wordpress.com/2011/11/20/feature-branches-vs-feature-toggles/>, and <http://blog.jayfields.com/2010/10/experience-report-feature-toggle-over.html>) during the dev process (to guard against incomplete features being deployed to production).  

Twelve-factor tells us to keep app configuration setting in environment variables.  Hence this libaray adds a tiny bit of convention on how feature toggle env vars are spelled.

As the ultimate acceptance of a feature is the market response, this library has been designed to work with rollout.

Installation
============

Add this line to your application's Gemfile:

    gem 'binflip'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install binflip



Usage
=====

Set an environment variable following a FEATURE_[name] pattern:

Procfile

    FEATURE_CHAT = 1
    FEATURE_UPLOAD_VIDEO = 1

(Or set the ENV vars manually)

Then in application setup / initialization:

    $toggle = Binflip.new


Check for toggles, using just the [name]:

    $toggle.active?(:chat)
    $toggle.active?(:upload_video)

NOTE: Absence of feature toggle env variable means the feature is not active.

binflip.js
=========

To use binflip.js, you need to include `vendor/assets/javascripts/binflip.js`, and have `JSON.parse` available (use https://github.com/douglascrockford/JSON-js/blob/master/json2.js if you are using an old browser).  If you are using Rails 3.1 or higher, including the Binflip gem will make it available, just require 'binflip' in your application.js manifest.

The javascript pattern is to build the feature set (for the current user) once during page load, and store the set of features as a data attribute in the `<body>` tag.

So in your `<body>` tag, do something like this:

    <body data-features='<%= $binflip.active_features(current_user).to_json %>'>

Then you can test for features in your javascript with:

    if (Binflip.isActive('feature')) {
      alert("Feature is active");
    }

Usage with Rollout
==================

Procfile

    FEATURE_CHAT = 1
    FEATURE_UPLOAD_VIDEO = 1

(Or set the ENV vars manually)

Then in application setup / initialization:

    $redis = Redis.new
    $rollout = Rollout.new($redis)
    $toggle = Binflip.new($rollout)


Check for toggles:

    $toggle.active?(:chat, @user)
    $toggle.active?(:upload_video, @user)

If Rollout is present, Binflip delegates all methods to it (such as `activate_user`).

Environment Keys and Case Sensitivity
=====================================

As it is customary to set `ENVIRONMENT_VARS` in all upcase, environment feature keys are upcase'd.  So you *must* set your env keys to all upcase -- e.g. `FEATURE_MY_COOL_FEATURE`.  But you can test with upcase, lowercase or as a symbol:

    $binflip.active?(:my_cool_feature)
    $binflip.active?('my_cool_feature')
    $binflip.active?('MY_COOL_FEATURE')

These are all equivalent and will test for `FEATURE_MY_COOL_FEATURE` in the `ENV` hash.  NOTE: this convention is only for `ENV` and not for rollout.


License
=======

Copyright (c) 2012 Brian Kaney

MIT License
