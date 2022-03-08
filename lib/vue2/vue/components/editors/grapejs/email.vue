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

editor.DomComponents.addType('test-component', {
    dragabble: false,
  model: {
    defaults: {
      testprop: 1,
    },
    init() {
      console.log('Local hook: model.init');
      this.listenTo(this, 'change:testprop', this.handlePropChange);
      // Here we can listen global hooks with editor.on('...')
    },
    updated(property, value, prevValue) {
      console.log('Local hook: model.updated',
        'property', property, 'value', value, 'prevValue', prevValue);
    },
    removed() {
      console.log('Local hook: model.removed');
    },
    handlePropChange() {
      console.log('The value of testprop', this.get('testprop'));
    }
  },
  view: {
    init() {
      console.log('Local hook: view.init');
    },
    onRender() {
      console.log('Local hook: view.onRender');
    },
  },
});

// A block for the custom component
editor.BlockManager.add('test-component', {
  label: 'Test Component',
  content: '<div data-gjs-type="test-component">Test Component</div>',
});


    }
}
</script>
<template>
    <div class="mailer-email-template">
        <div id="gjs">
            <div data-gjs-editable="false" data-gjs-removable="false">
                div 1
                <div>div 2
                    <button>button</button>
                </div>
            </div>
        </div>
    </div>
</template>
