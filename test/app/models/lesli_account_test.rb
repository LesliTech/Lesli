# test/models/lesli_account_test.rb
require Lesli::Engine.root.join("lib/test/lesli")

class LesliAccountTest < LesliModelTester
  fixtures :lesli_accounts
  set_fixture_class lesli_accounts: "Lesli::Account" # adjust if different

  test "fixture is valid" do
    assert lesli_accounts(:one).valid?
  end

  # --- Presence validations (recommended) ---
  test "requires status" do
    account = lesli_accounts(:one).dup
    account.status = nil
    assert_not account.valid?
    assert_includes account.errors[:status], "can't be blank"
  end

  test "requires email (db constraint)" do
  account = lesli_accounts(:one).dup
  account.email = nil

  assert_raises(ActiveRecord::NotNullViolation) do
    account.save!(validate: false)
  end
end

  test "email is unique (db index)" do
    account = lesli_accounts(:one).dup
    account.status = "active"
    account.name = "Unique Name"

    # Hit the DB unique index directly (even if you don't have validates_uniqueness_of)
    assert_raises ActiveRecord::RecordNotUnique do
      account.save!(validate: false)
    end
  end

  test "region defaults to america" do
    account = Lesli::Account.new(
      status: "active",
      email: "new-account@example.com"
      # region omitted on purpose
    )

    assert_equal "america", account.region
  end
end
