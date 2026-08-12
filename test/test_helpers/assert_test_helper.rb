module AssertTestHelper
  def assert_notice(text)
    assert_select "div", /#{text}/
  end
end
