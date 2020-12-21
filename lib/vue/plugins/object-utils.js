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
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
export default {

    install (Vue) {

        let pluralize = function(string) {
            if(string.match(/^[0-9]+$/)){
                return string
            }

            if(string.endsWith('y')){
                return string.slice(0, -1).concat('ies')
            }

            return string.concat('s')
        }

        let pluralizeArray = function(string_array){
            return string_array.map((string)=>{
                return pluralize(string)
            })
        }

        let parseCloudModule = function(cloud_module){
            let module_data = cloud_module.split('/')
            let object_name = module_data[module_data.length - 1]
            
            let cloud_object_name = {
                singular: object_name,
                plural: pluralize(object_name)
            }

            // This verifies if the engine is mounted in the root or not
            if(module_data.length > 1){
                let cloud_module_name = { }
                let engine_name = module_data[0]
                module_data = module_data.slice(1,-1)
                
                cloud_module_name.slash = [engine_name].concat(
                    pluralizeArray(module_data)
                ).filter((element) =>{
                    return element
                }).join('/')
    
                cloud_module_name.underscore = engine_name.concat(module_data.filter((element)=>{
                    return ! element.match(/^[0-9]+$/)
                }))
    
                return {
                    cloud_object_name: cloud_object_name,
                    cloud_module_name: cloud_module_name
                }
            }else{
                return {
                    cloud_object_name: cloud_object_name,
                    cloud_module_name: {
                        slash: '/',
                        underscore: '_'
                    }
                }
            }
        }

        // Transforms from camelcase to snake case
        let toSnakeCase = function(str){
            let initial_char = str[0].toLowerCase()
            str = str.substring(1)
            str = `${initial_char}${str.replace(/[A-Z]/g, letter => `_${letter.toLowerCase()}`)}`;
            return str
        }

        let translateEnum = function(translations, enum_prefix, value, default_value = value){
            if(! translations){
                return default_value
            }

            let new_value = translations[`${enum_prefix}_${value}`]

            if(new_value){
                return new_value
            }

            return default_value
        }

        let extractInitials = function(text){
            return text.split(" ").map((word)=>{
                if(word){
                    return word[0].toUpperCase()
                }else{
                    return ''
                }
            }).join("")
        }

        let calculateFontColor = function(color){
            // We extract the colors from the string using a regexp
            var color_value = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(color);
            if(color_value){

                color = {
                    r: parseInt(color_value[1], 16),
                    g: parseInt(color_value[2], 16),
                    b: parseInt(color_value[3], 16)
                }

                // We calculate the overall intensity of the color based on the 3 components
                if ((color.r*0.299 + color.g*0.587 + color.g*0.114) <= 186){
                    return "#ffffff"
                }
            }

            return "#000000";
        }
    
        Vue.prototype.object_utils = {
            pluralize,
            pluralizeArray,
            parseCloudModule,
            translateEnum,
            toSnakeCase,
            extractInitials,
            calculateFontColor
        }

    }
    
}
