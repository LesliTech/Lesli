namespace :data do
    namespace :import do

        desc ""
        task companies: :environment do
            account = Account.find(1)
            companies.each do |company|
                CloudHouse::Company.create({
                    detail_attributes: {
                        name: company['name']
                    },
                    account: account
                })
            end

        end

        desc ""
        task tasks: :environment do
            account = Account.find(1)
            tasks = read_file("crm_tasks")
            tasks.each_with_index do |task, index|
                p "processing task #{index} of #{tasks.length}"
                CloudFocus::Task.create({
                    detail_attributes: {
                        title: task['title'],
                        description: task['note'],
                        deadline: task['deadline']
                    },
                    account: account
                })
            end
        end

        def read_file filename
            path = Rails.root.join("storage", "#{filename}.json")
            JSON.parse(File.read(path))
        end

    end
end
