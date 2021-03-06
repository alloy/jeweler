Feature: generated test or spec
  In order to start a new gem
  A user should be able to
  generate a test or spec

  Scenario: bacon
    Given a working directory
    And I have configured git sanely
    When I generate a bacon project named 'the-perfect-gem' that is 'zomg, so good'
    Then 'spec/the_perfect_gem_spec.rb' should describe 'ThePerfectGem'

  Scenario: minitest
    Given a working directory
    And I have configured git sanely
    When I generate a minitest project named 'the-perfect-gem' that is 'zomg, so good'
    Then 'test/the_perfect_gem_test.rb' should define 'ThePerfectGemTest' as a subclass of 'Mini::Test::TestCase'

  Scenario: rspec
    Given a working directory
    And I have configured git sanely
    When I generate a rspec project named 'the-perfect-gem' that is 'zomg, so good'
    Then 'spec/the_perfect_gem_spec.rb' should describe 'ThePerfectGem'

  Scenario: shoulda
    Given a working directory
    And I have configured git sanely
    And I intend to test with shoulda
    When I generate a project named 'the-perfect-gem' that is 'zomg, so good'
    Then 'test/the_perfect_gem_test.rb' should define 'ThePerfectGemTest' as a subclass of 'Test::Unit::TestCase'

  Scenario: testunit
    Given a working directory
    And I have configured git sanely
    When I generate a testunit project named 'the-perfect-gem' that is 'zomg, so good'
    Then 'test/the_perfect_gem_test.rb' should define 'ThePerfectGemTest' as a subclass of 'Test::Unit::TestCase'

  Scenario: micronaut
    Given a working directory
    And I have configured git sanely
    When I generate a micronaut project named 'the-perfect-gem' that is 'zomg, so good'
    Then 'examples/the_perfect_gem_example.rb' should describe 'ThePerfectGem'
