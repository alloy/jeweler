# Use vendored gem because of limited gem availability on runcoderun
# This is loosely based on 'vendor everything'.
Dir[File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', '**')].each do |dir|
  lib = "#{dir}/lib"
  $LOAD_PATH.unshift(lib) if File.directory?(lib)
end

require 'test/unit'

require 'rubygems'
require 'shoulda'
require 'ruby-debug'
require 'rr'
require 'output_catcher'
require 'time'

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')
require 'jeweler'

$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'shoulda_macros/jeweler_macros'

TMP_DIR = File.expand_path('../tmp', __FILE__)
FIXTURE_DIR = File.expand_path('../fixtures', __FILE__)

class Test::Unit::TestCase
  include RR::Adapters::TestUnit unless include?(RR::Adapters::TestUnit)

  def catch_out(&block)
     OutputCatcher.catch_out do
       block.call
     end
  end

  def tmp_dir
    TMP_DIR
  end

  def fixture_dir
    File.join(FIXTURE_DIR, 'bar')
  end

  def remove_tmpdir!
    FileUtils.rm_rf(tmp_dir)
  end

  def create_tmpdir!
    FileUtils.mkdir_p(tmp_dir)
  end

  def build_spec(*files)
    Gem::Specification.new do |s|
      s.name = "bar"
      s.summary = "Simple and opinionated helper for creating Rubygem projects on GitHub"
      s.email = "josh@technicalpickles.com"
      s.homepage = "http://github.com/technicalpickles/jeweler"
      s.description = "Simple and opinionated helper for creating Rubygem projects on GitHub"
      s.authors = ["Josh Nichols"]
      s.files = FileList[*files] unless files.empty?
    end
  end
end
