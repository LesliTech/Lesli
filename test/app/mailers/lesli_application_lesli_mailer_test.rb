# frozen_string_literal: true

require "test_helper"

module Lesli
    class ApplicationLesliMailerTest < ActionMailer::TestCase
        test "builds absolute URLs from Action Mailer configuration" do
            with_default_url_options(
                host: "accounts.example.com",
                protocol: :https,
                port: 8443
            ) do
                url = ApplicationLesliMailer.new.build_url(
                    "/welcome",
                    token: "token with spaces"
                )

                assert_equal(
                    "https://accounts.example.com:8443/welcome?token=token+with+spaces",
                    url
                )
            end
        end

        test "uses HTTP when no protocol is configured" do
            with_default_url_options(host: "example.com") do
                assert_equal(
                    "http://example.com/",
                    ApplicationLesliMailer.new.build_url("/")
                )
            end
        end

        test "raises a useful error when the host is missing" do
            with_default_url_options({}) do
                error = assert_raises(ArgumentError) do
                    ApplicationLesliMailer.new.build_url("/")
                end

                assert_includes error.message, "default_url_options[:host]"
            end
        end

        private

        def with_default_url_options(options)
            original_options = Rails.application.config.action_mailer.default_url_options
            Rails.application.config.action_mailer.default_url_options = options
            yield
        ensure
            Rails.application.config.action_mailer.default_url_options = original_options
        end
    end
end
