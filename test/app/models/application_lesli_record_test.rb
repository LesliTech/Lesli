require "test_helper"

class ApplicationLesliRecordTest < LesliTesting::ModelTester

    TestRecord = Class.new(Lesli::ApplicationLesliRecord) do
        self.table_name = "lesli_users" # any existing table; we won't persist
    end

    test "generate_resource_uid returns prefix-YYM-LETTERS with default args" do
        travel_to(Time.zone.local(2026, 2, 22, 12, 0, 0)) do
            uid = TestRecord.new.generate_resource_uid(prefix: "LID", length: 4)

            # 2026-02 => year%100 = 26, month = 2 => "262"
            assert_match(/\ALID-262-[A-Z]{4}\z/, uid)

            letters = uid.split("-").last
            assert_equal 4, letters.length
            assert letters.chars.all? { |ch| Lesli::ApplicationLesliRecord::CHARSET.include?(ch) },
            "Expected letters to be from CHARSET only"
        end
    end

    test "generate_resource_uid respects length option" do
        travel_to(Time.zone.local(2026, 2, 22)) do
            uid = TestRecord.new.generate_resource_uid(prefix: "LID", length: 8)
            assert_match(/\ALID-262-[A-Z]{8}\z/, uid)
        end
    end

    test "generate_resource_uid omits prefix when prefix is nil" do
        travel_to(Time.zone.local(2026, 2, 22)) do
            uid = TestRecord.new.generate_resource_uid(prefix: nil, length: 4)
            assert_match(/\A262-[A-Z]{4}\z/, uid)
        end
    end

    test "generate_resource_uid produces letters from the unambiguous charset" do
        travel_to(Time.zone.local(2026, 2, 22)) do
            uid = TestRecord.new.generate_resource_uid(prefix: "LID", length: 40)
            letters = uid.split("-").last

            # Strong check: every char is from CHARSET
            assert letters.chars.all? { |ch| Lesli::ApplicationLesliRecord::CHARSET.include?(ch) }

            # Optional explicit checks for common ambiguous chars:
            refute_includes letters, "I"
            refute_includes letters, "O"
        end
    end
end
