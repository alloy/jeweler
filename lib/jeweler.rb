require 'date'
require 'rubygems/builder'

require 'jeweler/version_helper'
require 'jeweler/gemspec_helper'
require 'jeweler/errors'
require 'jeweler/generator'
require 'jeweler/generator/options'
require 'jeweler/generator/application'

require 'jeweler/commands'

require 'jeweler/tasks'

require 'jeweler/specification'

# A Jeweler helps you craft the perfect Rubygem. Give him a gemspec, and he takes care of the rest.
class Jeweler

  attr_reader :gemspec, :gemspec_helper
  attr_accessor :base_dir, :output

  def initialize(gemspec, base_dir = '.')
    raise(GemspecError, "Can't create a Jeweler with a nil gemspec") if gemspec.nil?

    @gemspec = gemspec
    @gemspec.extend(Specification)
    @gemspec.set_jeweler_defaults(base_dir)

    @base_dir       = base_dir
    @repo           = Git.open(base_dir) if in_git_repo?
    @version_helper = Jeweler::VersionHelper.new(base_dir)
    @output         = $stdout
    @gemspec_helper = GemSpecHelper.new(@gemspec, base_dir)
  end

  # Major version, as defined by the gemspec's Version module.
  # For 1.5.3, this would return 1.
  def major_version
    @version_helper.major
  end

  # Minor version, as defined by the gemspec's Version module.
  # For 1.5.3, this would return 5.
  def minor_version
    @version_helper.minor
  end

  # Patch version, as defined by the gemspec's Version module.
  # For 1.5.3, this would return 5.
  def patch_version
    @version_helper.patch
  end

  # Human readable version, which is used in the gemspec.
  def version
    @version_helper.to_s
  end

  # Writes out the gemspec
  def write_gemspec
    build_command(Jeweler::Commands::WriteGemspec).run
  end

  # Validates the project's gemspec from disk in an environment similar to how 
  # GitHub would build from it. See http://gist.github.com/16215
  def validate_gemspec
    build_command(Jeweler::Commands::ValidateGemspec).run
  end

  # is the project's gemspec from disk valid?
  def valid_gemspec?
    gemspec_helper.valid?
  end

  def build_gem
    build_command(Jeweler::Commands::BuildGem).run
  end

  def install_gem
    build_command(Jeweler::Commands::InstallGem).run
  end

  # Bumps the patch version.
  #
  # 1.5.1 -> 1.5.2
  def bump_patch_version(options = {})
    build_command(Jeweler::Commands::Version::BumpPatch).run
  end

  # Bumps the minor version.
  #
  # 1.5.1 -> 1.6.0
  def bump_minor_version(options = {})
    build_command(Jeweler::Commands::Version::BumpMinor).run
  end

  # Bumps the major version.
  #
  # 1.5.1 -> 2.0.0
  def bump_major_version(options = {})
    build_command(Jeweler::Commands::Version::BumpMajor).run
  end

  # Bumps the version, to the specific major/minor/patch version, writing out the appropriate version.rb, and then reloads it.
  def write_version(major, minor, patch, options = {})
    command = build_command(Jeweler::Commands::Version::Write)
    command.major = major
    command.minor = minor
    command.patch = patch

    command.run
  end

  def release
    build_command(Jeweler::Commands::Release).run
  end

  protected

  def build_command(command_class)
    command = command_class.new
    command.repo = @repo if command.respond_to?(:repo=)
    command.version_helper = @version_helper if command.respond_to?(:version_helper=)
    command.gemspec = @gemspec if command.respond_to?(:gemspec=)
    command.commit = true if command.respond_to?(:commit=)
    command.version = self.version if command.respond_to?(:version=)
    command.output = output if command.respond_to?(:output=)
    command.base_dir = @base_dir if command.respond_to?(:base_dir=)
    command.gemspec_helper = GemSpecHelper.new(@gemspec, @base_dir) if command.respond_to?(:gemspec_helper)

    command
  end

  def in_git_repo?
    File.exists?(File.join(self.base_dir, '.git'))
  end
end

