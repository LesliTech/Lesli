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


// · vue http and pinia http plugins share axios customization
import { useUrl } from "../composables/url"


// · 
export default () => {

    var activeMsg = 0

    function msg(text, type="success") {

        activeMsg++

        var duration = 2800

        var toastEl = document.createElement('div')

        toastEl.innerHTML = text
        toastEl.className = 'lesli-msg notification is-' + type

        if (activeMsg > 1) {
            toastEl.style.top = (52 * activeMsg) + 'px'
        }

        document.body.appendChild(toastEl)
    
        setTimeout(function () {
            activeMsg--
            toastEl.className += ' hide'
            setTimeout(function () {
                toastEl.parentNode.removeChild(toastEl)
            }, 450)
        }, duration)
    }

    return {
        msg: {
            success: (text) => msg(text, "success")
        }
    }

    
};
