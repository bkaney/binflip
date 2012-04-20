Binflip
=======

Simple environmental feature toggling (that works well with Rollout)


Description
===========

Keeping true to twelve-factor application principles <http://12factor.net>, this simple library uses environment variables, with a straightforward naming convention, to specify feature toggles.  

Rollout Compatibility
======================

If Rollout <https://github.com/jamesgolick/rollout> is present, it will delegate all methods, adding to `active?` a preliminary test to see if the environment toggle is on before checking rollout.

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

Usage with Rollout
==================

Procfile

    FEATURE_CHAT = 1
    FEATURE_UPLOAD_VIDEO = 1

(Or set the ENV vars manually)

Then in application setup / initialization:

    $redis = Redis.new
    $toggle = Binflip.new($redis)


Check for toggles:

    $toggle.active?(:chat, @user)
    $toggle.active?(:upload_video, @user)

If Rollout is present, Binflip delegates all methods to it (such as `activate_user`).

License
=======

Copyright (c) 2012 Brian Kaney

MIT License
