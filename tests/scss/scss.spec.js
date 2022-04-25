/*

Copyright (c) 2022, all rights reserved.

All the information provided by this platform is protected by international laws related  to 
industrial property, intellectual property, copyright and relative international laws. 
All intellectual or industrial property rights of the code, texts, trade mark, design, 
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

*/


// · 
const path = require('path')
const sassTrue = require('sass-true')
const glob = require('glob')


// · Custom sass importer, due sass (node, dart) @import implementation
// · works a bit different that the ruby sass implementation
function importer(url, prev, done) {

    if (url === 'lesli-css') {
        url = path.resolve('node_modules', url);
    }

    return { file: url };

}


// · Scan and load all the tests found
describe('Running SASS tests', () => {

    // Find all of the Sass files that end in `*.spec.scss` in any directory of this project.
    // I use path.resolve because True requires absolute paths to compile test files.
    const sassTestFiles = glob.sync(path.resolve(process.cwd(), 'tests/**/**/*.spec.scss'))

    

    // Run True on every file found with the describe and it methods provided
    sassTestFiles.forEach(file => sassTrue.runSass({ importer, file }, { describe, it }))

})
