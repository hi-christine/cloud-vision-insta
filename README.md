# cloud-vision-insta
Cloud Vision Ruby Project to analyze instagram accounts

This GitHub was created by [Christine](https://twitter.com/tech_christine) and [Ryan](https://twitter.com/ryanhos) for the  talk "What does your Instagram say about you? Exploring Google Cloud Vision AI & Machine Learning Products". We presented this at a couple conferences and shows how we made use of these APIs and libraries. 

This project shows different usage of Google Cloud Vision Ruby Library to analyze a variety of Instagram accounts and makes use of Google Cloud storage to host the images.
This repo is very tied to certain folders and directories that were used locally, and will need modifications before it could be used.

# Required Setup
* You are going to have to have create a Google Cloud Platform project and enabled all the billing, check out the quickstart [here](https://cloud.google.com/vision/docs/quickstart-client-libraries)

# Under the hood
* Ruby (No Rails)
* Rspec
* Ruby Vision API Client Libraries
* Google Cloud Storage
* Rmagick (Ruby binding to Imagemagick)
* MagicCloud tag cloud gem

# Setup ImageMagick on Mac OS
* Assuming you're in the `admin` group...
* `sudo mkdir /usr/local/Frameworks`
* `sudo chgrp admin /usr/local/Frameworks`
* `brew install ImageMagick`

# Reference Links
* https://cloud.google.com/vision/
* https://cloud.google.com/vision/docs/
* https://googleapis.github.io/google-cloud-ruby/docs/
* https://github.com/GoogleCloudPlatform/ruby-docs-samples/blob/master/vision/quickstart.rb
* https://github.com/zverok/magic_cloud

# Thank You
These were the instagram accounts used for analysis
* @ripleyandrue
* @visit_nebraska
* @wolffolins
* @expertvagabond
* @iloveny
* @letterfolk
* @myraswim
* @visitcalifornia
* @nationalportraitgallery
* @nike