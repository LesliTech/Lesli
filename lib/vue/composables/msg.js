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
export function useMsg() {

    var activeMsg = 0

    function msg(text, type="success") {

        // messages in queue
        activeMsg++

        // visible time of the message
        var duration = 2800

        // create a new raw html div in the root of the html document
        var toastEl = document.createElement('div')

        // build the message
        toastEl.innerHTML = text
        toastEl.className = 'lesli-msg notification is-' + type

        // use the count of the messages in queue to calculate the position of the new message
        if (activeMsg > 0) {
            toastEl.style.top = (52 * activeMsg) + 'px'
        }

        // show the new message component
        document.body.appendChild(toastEl)
    
        // start counting to hide the message
        setTimeout(function () {

            // remove messages from the queue
            activeMsg--

            // hide message
            toastEl.className += ' hide'

            // wait to remove the html from document, so the transition animation works
            // maybe we should reset the timer every time here?
            setTimeout(()=>{
                document.querySelectorAll('.lesli-msg.hide').forEach(el => {
                    el.parentNode.removeChild(el)
                })
            }, 1000)
            
        }, duration)
    }

    return {
        info: (text) => msg(text, "info"),
        danger: (text) => msg(text, "danger"),
        success: (text) => msg(text, "success"),
        warning: (text) => msg(text, "warning")
    }

}
