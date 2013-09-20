ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'

MiniTest::Reporters.use!

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  def token
    '23j0f023912309r5u11fas'
  end

  def token_fred
    '23j0f023912309r5u11fas'
  end

  def token_bob
    'adflkj23kj23lkj235l;23'
  end

  def invalid_token
    'INVALID_TOKEN'
  end

  def id_bob
    12346
  end

  def id_fred
    12345
  end

end
