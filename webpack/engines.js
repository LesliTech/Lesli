var fs = require("fs")
var path = require("path")
var yaml = require("js-yaml")

var entries = []

// get specific modules to work with, example: npm run webpack -- babel bell
const requestedEngines = process.argv.slice(5)

// · set the path to the engines folder
const pathEngines = path.resolve("engines")

// exit configuration builder if no engines installed
if (!fs.existsSync(pathEngines)) { return entries; }


// get the installed engines
let engines = fs.readdirSync(pathEngines);


// remove the keep file from the engines directory
engines = engines.filter(directory => directory != ".gitkeep")


// filter found engines to get only the ones that are ready to work with vue
engines = engines.filter(engine => {

    // get and parse engine information files (lesli.yml)
    let lesliConfigPath = path.resolve(pathEngines, engine, "lesli.yml")

    // exit if lesli.yml does not exists
    if (!fs.existsSync(lesliConfigPath)) { return false }

    // load LesliConfig
    let lesliConfig = yaml.load(fs.readFileSync(lesliConfigPath))

    // exit if engine does not have to be loaded
    if (lesliConfig.info.load == false) { return false }

    // build engine code from engine name
    lesliConfig.info["code"] = lesliConfig.info["name"].split(/(?=[A-Z])/).join('_').toLowerCase()

    // check if user sent specific modules to work with through "webpack -- engine1 engine2 etc.."
    if (requestedEngines.length > 0) {

        // check if current engine belongs to the list of desire engines
        if (!requestedEngines.includes(lesliConfig.info.code.replace("cloud_", ""))) {

            return false

        }

    }


    // check if vue folder exists for given engine
    if (!fs.existsSync(path.resolve(pathEngines, engine, "app", "vue"))) {
        return false
    }

    // include engine into the collections of active engines
    return lesliConfig.info.code == engine

})


// 
engines.forEach(engine => {

    // clone webpack core configuration (shallow copy) 
    config = {
        entry: {},
        output: {
            path: path.resolve(pathEngines, engine, "app", "assets", "javascripts")
        }
    }

    // scan the vue folder to get all the vue apps
    var appFolder = path.resolve(pathEngines, engine, "app", "vue")

    // filter to remove the folders
    let files = fs.readdirSync(appFolder, { withFileTypes: true })
        .filter(item => !item.isDirectory())
        .map(item => item.name)

    // register every vue app found
    files.forEach(file => {

        // path to the vue app main mount file
        let appPath = path.resolve(appFolder, file)

        // stop process if vue app does not exists
        if (!fs.existsSync(appPath)) { return; }

        let appname = path.parse(file).name

        // convert the name of the engine to CamelCase from engine_name to EngineName
        const alias = engine.split("_").map(str => str.charAt(0).toUpperCase() + str.replace("cloud_").slice(1)).join("");

        // add vue apps found into the webpack compilation pipeline
        config.entry[(`${engine}/${appname}`)] = `${alias}/${appname}`

    })


    // check if the engine has vue apps to compile
    if (Object.keys(config.entry).length <= 0) { return }


    entries.push({ code: engine, config })

})

module.exports = entries
