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

            # next if engine name does not match
            next unless engine_info['name'] == entry

            engines.push(engine_info)

        end

        engines

    end

end
