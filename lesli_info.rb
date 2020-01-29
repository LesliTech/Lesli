require 'json'

module LesliInfo

    def LesliInfo.engines
        engines = []
        Dir.entries("./engines").each do |entry|
            
            # next if entry is not an engine
            next if entry == "."
            next if entry == ".."
            next if entry == ".gitkeep"
            
            # build path to lesli engine info file
            path = File.join("./engines", entry, "lesli.json")
            
            # next if lesli engine info file does not exist
            next unless File.exist?(path)
            
            # next if lesli engine info file does not contain valid json data
            begin
                engine_info = JSON.parse(File.read(path))
            rescue JSON::ParserError
                next
            end

            # next if engine load is false
            next if engine_info['load'] == false

            # next if engine name does not match
            next unless engine_info['name'] == entry

            engines.push(engine_info)

        end

=begin
        [, {
            name: 'CloudHappy',
            code: 'cloud_happy',
            github_ssh: 'git@github.com:LesliTech/CloudHappy.git',
            github_url: 'https://github.com/LesliTech/CloudHappy'
        }, {
            name: 'CloudSeller',
            code: 'cloud_seller',
            github_ssh: 'git@github.com:LesliTech/CloudSeller.git',
            github_url: 'https://github.com/LesliTech/CloudSeller'
        }, {
            name: 'CloudLeaf',
            code: 'cloud_leaf',
            github_ssh: 'git@github.com:LesliTech/CloudLeaf.git',
            github_url: 'https://github.com/LesliTech/CloudLeaf'
        }, {
            name: 'CloudDrop',
            code: 'cloud_drop',
            github_ssh: 'git@github.com:LesliTech/CloudDrop.git',
            github_url: 'https://github.com/LesliTech/CloudDrop'
        }, {
            name: 'CloudMailer',
            code: 'cloud_mailer',
            github_ssh: 'git@github.com:LesliTech/CloudMailer.git',
            github_url: 'https://github.com/LesliTech/CloudMailer'
        }, {

        }, {
            name: 'CloudChaos',
            code: 'cloud_chaos',
            github_ssh: 'git@github.com:LesliTech/CloudChaos.git',
            github_url: 'https://github.com/LesliTech/CloudChaos'
        }, {
            
        }, {
            name: 'CloudPizza',
            code: 'cloud_pizza',
            github_ssh: 'git@github.com:LesliTech/CloudPizza.git',
            github_url: 'https://github.com/LesliTech/CloudPizza'
        }, {
            name: 'CloudNotes',
            code: 'cloud_notes',
            github_ssh: 'git@github.com:LesliTech/CloudNotes.git',
            github_url: 'https://github.com/LesliTech/CloudNotes'
        }, {
            name: 'CloudLesli',
            code: 'cloud_lesli',
            github_ssh: 'git@github.com:LesliTech/CloudLesli.git',
            github_url: 'https://github.com/LesliTech/CloudLesli'
        }, {
            name: 'CloudSocial',
            code: 'cloud_social',
            github_ssh: 'git@github.com:LesliTech/CloudSocial.git',
            github_url: 'https://github.com/LesliTech/CloudSocial'
        }, {
            name: 'CloudBell',
            code: 'cloud_bell',
            github_ssh: 'git@github.com:LesliTech/CloudBell.git',
            github_url: 'https://github.com/LesliTech/CloudBell'
        }, {
            name: 'CloudBooks',
            code: 'cloud_books',
            github_ssh: 'git@github.com:LesliTech/CloudBooks.git',
            github_url: 'https://github.com/LesliTech/CloudBooks'
        }, {
            name: 'CloudWallet',
            code: 'cloud_wallet',
            github_ssh: 'git@github.com:LesliTech/CloudWallet.git',
            github_url: 'https://github.com/LesliTech/CloudWallet'
        }, {
            name: 'CloudThings',
            code: 'cloud_things',
            github_ssh: 'git@github.com:LesliTech/CloudThings.git',
            github_url: 'https://github.com/LesliTech/CloudThings'
        }, {
            name: 'CloudKb',
            code: 'cloud_kb',
            github_ssh: 'git@github.com:LesliTech/CloudKb.git',
            github_url: 'https://github.com/LesliTech/CloudKb'
        }, {
            name: 'CloudHelp',
            code: 'cloud_help',
            github_ssh: 'git@github.com:LesliTech/CloudHelp.git',
            github_url: 'https://github.com/LesliTech/CloudHelp'
        }, {
            name: 'CloudPortal',
            code: 'cloud_portal',
            github_ssh: 'git@github.com:LesliTech/CloudPortal.git',
            github_url: 'https://github.com/LesliTech/CloudPortal'
        }, {
            name: 'CloudBug',
            code: 'cloud_bug',
            github_ssh: 'git@github.com:LesliTech/CloudBug.git',
            github_url: 'https://github.com/LesliTech/CloudBug'
        }, {
            name: 'CloudPanel',
            code: 'cloud_panel',
            github_ssh: 'git@github.com:LesliTech/CloudPanel.git',
            github_url: 'https://github.com/LesliTech/CloudPanel'
        }, {
            name: 'CloudLock',
            code: 'cloud_lock',
            github_ssh: 'git@github.com:LesliTech/CloudLock.git',
            github_url: 'https://github.com/LesliTech/CloudLock'
        }, {
            
        }]
=end

        engines

    end

end
