require "test_helper"

class Exercism::Local::Tooling::WebserverTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Exercism::Local::Tooling::Webserver::VERSION
  end

  def test_it_does_something_useful
    assert false
  end
end
