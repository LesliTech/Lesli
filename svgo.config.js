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

// SVG preprocessor,
// this NodeJS module helps to clean the svg files so it is easy to embed in the html through the 
// lesli_svg Rails helper
// this must be used before the svgeez gem
module.exports = {
    js2svg: {
        pretty: true,
    },
    plugins: [
        {
            name: 'preset-default',
            params: {
                overrides: {
                    inlineStyles: {
                        onlyMatchedOnce: false,
                    },
                    removeViewBox: false
                },
            },
        },
        {
            name: 'convertStyleToAttrs'
        },
        {
            name: 'prefixIds'
        },
        {
            name: 'removeStyleElement'
        },
        {
            name: 'removeScriptElement'
        }
    ],
};
