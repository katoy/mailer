# -*- coding: utf-8 -*-

require 'rubygems'

require 'coveralls'
require 'simplecov'
require 'simplecov-rcov'
Coveralls.wear!

# simplecov, rcov, coderails の３通りの書式のレポートを生成する。
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
                                                           SimpleCov::Formatter::HTMLFormatter,
                                                           SimpleCov::Formatter::RcovFormatter,
                                                           Coveralls::SimpleCov::Formatter
                                                          ]
SimpleCov.start

# ---------------
Dir.glob('./src/**/*.rb') { |f| require f }
