/*

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

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
