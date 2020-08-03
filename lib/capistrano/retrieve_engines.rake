desc 'Clones my_gem from Github to vendor/git'
    task :retrieve_engines do
        on roles(:app), in: :sequence do

            # engines to install
            engines=[
                "git@github.com:leitfaden/Lesli.git",
                "git@github.com:leitfaden/CloudBabel.git",
                "git@github.com:leitfaden/CloudBell.git",
                "git@github.com:leitfaden/CloudDispatcher.git",
                "git@github.com:leitfaden/CloudDriver.git",
                "git@github.com:leitfaden/CloudFocus.git",
                "git@github.com:leitfaden/CloudHouse.git",
                "git@github.com:leitfaden/CloudMailer.git",
                "git@github.com:leitfaden/DeutscheLeibrenten.git"
            ]

            # installation path
            engine_path=Rails.root.join("engines")

            engines.each do |engine_repo|
                info "cloning engine #{engine_repo}"
                execute "git clone #{engine_repo} #{gem_path}"
            end

        end
    end
end
