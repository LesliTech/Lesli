/*

Copyright (c) 2020, all rights reserved.

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


// · Plugin initializing 
export default {

    install (Vue, lesli) {
    

        //delete lesli.current_user.abilities

        lesli['colors'] = function(palette, variant= 500) {

            var colors = {

                // · blue
                blue: {
                    100: "#8cd5ff",
                    300: "#64baff",
                    500: "#3689e6",
                    700: "#0d52bf",
                    900: "#002e99" 
                },
            
                // · Administration
                bubble: {
                    100: "#fe9ab8",
                    300: "#f4679d",
                    500: "#de3e80",
                    700: "#bc245d",
                    900: "#910e38"
                },
            
                // · Sales & Marketing
                grape: {
                    100: "#e4c6fa",
                    300: "#cd9ef7",
                    500: "#a56de2",
                    700: "#7239b3",
                    900: "#452981" 
                },
            
                // · Productivity & Workteam
                lime: {
                    100: "#d1ff82",
                    300: "#9bdb4d",
                    500: "#68b723",
                    700: "#3a9104",
                    900: "#206b00" 
                },
            
                // · Finance
                orange: {
                    100: "#ffc27d",
                    300: "#ffa154",
                    500: "#f37329",
                    700: "#cc3b02",
                    900: "#a62100" 
                },
            
                // · Analytics
                berry: {
                    100: "#ff8c82",
                    300: "#ed5353",
                    500: "#c6262e",
                    700: "#a10705",
                    900: "#7a0000" 
                },
            
                // · Intelligence
                cocoa: {
                    100: "#a3907c",
                    300: "#8a715e",
                    500: "#715344",
                    700: "#57392d",
                    900: "#3d211b" 
                },
            
                // · IT & Help Desk
                banana: {
                    100: "#fff394",
                    300: "#ffe16b",
                    500: "#f9c440",
                    700: "#d48e15",
                    900: "#ad5f00" 
                },
            
                // · Security & Privacy
                slate: {
                    100: "#95a3ab",
                    300: "#667885",
                    500: "#485a6c",
                    700: "#273445",
                    900: "#0e141f" 
                },
            
                // · Integrations
                mint: {
                    100: "#89ffdd",
                    300: "#43d6b5",
                    500: "#28bca3",
                    700: "#0e9a83",
                    900: "#007367"
                },
            
                // · 
                black: {
                    100: "#666666",
                    300: "#4d4d4d",
                    500: "#333333",
                    700: "#1a1a1a",
                    900: "#000000" 
                },
            
                // · 
                silver: {
                    100: "#fafafa",
                    300: "#d4d4d4",
                    500: "#abacae",
                    700: "#7e8087",
                    900: "#555761" 
                },
            
                // · Solid standard colors
                solid: {
                    white: "#FFFFFF"
                },

                charts: [
                    "#005380",
                    "#20a7d8",
                    "#0a0a0a",

                    "#4682B4",
                    "#7285A5",
                    "#4C516D",
                    "#6593F5",
                    "#008081",
                    "#008ECC",
                    "#0F52BA",
                    "#4F97A3",
                    "#0080FF",
                    "#81D8D0",
                    "#1034A6",
                    "#89CFF0",
                    "#0E4D92",
                    "#57A0D3",
                    "#000080",
                    "#588BAE",
                    "#003152",
                    "#95C8D8",
                    "#1D2951",
                    "#B0DFE5",
                    "#111E6C"
                ]

            }

            if (palette == "charts") {
                return colors[palette]
            }

            return colors[palette][variant]
        
        }

        Vue.prototype.lesli = lesli

    }
    
}
