<script>

import grapesjs from 'grapesjs';

import blockFoundationGrid from './email/blocks/foundation-grid'
import blockFoundationButton from './email/blocks/foundation-button'
import blockFoundationCallout from './email/blocks/foundation-callout'
import blockFoundationMenu from './email/blocks/foundation-menu'
import blockFoundationSpacer from './email/blocks/foundation-spacer'
import blockFoundationWrapper from './email/blocks/foundation-wrapper'


export default {
    mounted() {
        var editor = grapesjs.init({
            container: '#gjs',
            fromElement: true,
            height: '600px',
            width: 'auto',
            storageManager: false,
            panels: {  },
            canvas: {
                styles: [stylesheet_path]
            },
            plugins: ["gjs-blocks-basic"],
            pluginsOpts: {
                "gjs-blocks-basic": {
                }
            }
        })

        blockFoundationButton(editor)
        blockFoundationGrid(editor)
        blockFoundationCallout(editor)
        blockFoundationMenu(editor)
        blockFoundationSpacer(editor)
        blockFoundationWrapper(editor)

        editor.getConfig().showDevices = 0;
        editor.Panels.addPanel({ id: "devices-c" }).get("buttons").add([
            { id: "set-device-desktop",command: function(e) { return e.setDevice("Desktop") }, className: "fa fa-desktop", active: 1},
            { id: "set-device-tablet", command: function(e) { return e.setDevice("Tablet") }, className: "fa fa-tablet" },
            { id: "set-device-mobile", command: function(e) { return e.setDevice("Mobile portrait") }, className: "fa fa-mobile" },
        ]);

        editor.Panels.render();

    }
}
</script>
<template>
    <div class="mailer-email-template">
        <div id="gjs">
            <h1>list of activities to keep the platform running</h1>
            <div id="blocks"></div>
        </div>
    </div>
</template>
