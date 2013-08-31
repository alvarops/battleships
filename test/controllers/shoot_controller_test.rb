require 'test_helper'

class ShootControllerTest < ActionController::TestCase
  test 'GET #new, {token, game, x, y}' do
    shoots_count_before = Shoot.all.size

    get :new, {token: '23j0f023912309r5u11fas', game: 1, x: 1, y: 1}

    shoots_count_after = Shoot.all.size

    assert_equal shoots_count_after, 1 + shoots_count_before
  end
end