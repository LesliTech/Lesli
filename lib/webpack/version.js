
const fs = require("fs")
const dayjs = require("dayjs")
const { useLesliDebug } = require("lesli-vue/composables")
const advancedFormat = require("dayjs/plugin/advancedFormat")
dayjs.extend(advancedFormat)
const debug = useLesliDebug()


// · Update compilation version for frontend and backend
module.exports = (env, engine) => {
        
    // do not change if development
    if (env.mode != "production") {
        return 
    }


    // set the path to the engine version file by default
    let engine_version_file = `../../engines/${engine.dir}/lib/${engine.code}/version.rb`

    fs.readFile(engine_version_file, "utf8", (err, data) => {

        if (err) {
            return console.log(err)
        }

        // Unix Timestamp in second
        let build = dayjs().format("X")

        data = data.split("\n")
        data[2] = `  BUILD = "${build}\"`

        fs.writeFile(engine_version_file, data.join("\n"), "utf8", function (err) {
            if (err) return console.log(err)
        })

        debug.info(`update version of: ${engine.dir}, to: ${build}`)

    })
}
