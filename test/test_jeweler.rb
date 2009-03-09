require 'test_helper'

class TestJeweler < Test::Unit::TestCase

  def setup
    @now = Time.now
    stub(Time).now { @now }
    remove_tmpdir!
  end

  def teardown
    remove_tmpdir!
  end

  context "Initializing jewewler in a blank directory" do
    setup do
      create_tmpdir!
      @jeweler = Jeweler.new(build_spec, tmp_dir)
    end

    should "not create a VERSION.yml" do
      assert ! File.exists?(File.join(tmp_dir, 'VERSION.yml'))
    end
  end

  context "A Jeweler with a VERSION.yml" do
    setup do
      FileUtils.cp_r(fixture_dir, tmp_dir)

      @jeweler = Jeweler.new(build_spec, tmp_dir)
      @jeweler.output = StringIO.new
    end

    should_have_major_version 1
    should_have_minor_version 5
    should_have_patch_version 2
    should_be_version '1.5.2'

    context "bumping the patch version" do
      setup do
        @jeweler.bump_patch_version 
      end
      should_bump_version 1, 5, 3
    end

    context "bumping the minor version" do
      setup do
        @jeweler.bump_minor_version
      end

      should_bump_version 1, 6, 0
    end

    context "bumping the major version" do
      setup do
        @jeweler.bump_major_version
      end

      should_bump_version 2, 0, 0
    end

    context "with a gemspec extended with Jeweler::Specification" do
      should "set defaults" do
        assert_equal %w{ foo_the_ultimate_bin }, @jeweler.gemspec.executables
      end
    end

    context "writing the gemspec" do
      setup do
        @jeweler.write_gemspec
        @output = @jeweler.output.string
      end

      should "create bar.gemspec" do
        assert File.exists?(File.join(tmp_dir, 'bar.gemspec'))
      end

      should "have created a valid gemspec" do
        assert @jeweler.valid_gemspec?
      end

      should "output the name of the gemspec" do
        assert_match 'bar.gemspec', @output
      end

      context "re-reading the gemspec" do
        setup do
          gemspec_path = File.join(tmp_dir, 'bar.gemspec')
          data = File.read(gemspec_path)

          @parsed_spec = eval("$SAFE = 3\n#{data}", binding, gemspec_path)
        end

        should "have version 1.5.2" do
          assert_equal '1.5.2', @parsed_spec.version.version
        end

        should "have date filled in" do
          assert_equal Time.local(@now.year, @now.month, @now.day), @parsed_spec.date
        end
      end
    end
  end

  should "raise an exception when created with a nil gemspec" do
    assert_raises Jeweler::GemspecError do
      @jeweler = Jeweler.new(nil, tmp_dir)
    end
  end

end
