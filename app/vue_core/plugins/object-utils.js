/*
Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@license  Propietary - all rights reserved.
@version  0.1.0-alpha

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
        }
    
        Vue.prototype.object_utils = {
            pluralize,
            pluralizeArray,
            parseCloudModule
        }

    }
    
}
