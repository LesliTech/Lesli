<script>

import grapesjs from 'grapesjs';
import grapesJSMJML from 'grapesjs-mjml'

export default {
    mounted() {

        var editor = grapesjs.init({
            fromElement: 1,
            container: '#gjs',
            height: '300px',
            width: 'auto',
            storageManager: false,
            panels: { defaults: [] },
            avoidInlineStyle : false,
            plugins: [grapesJSMJML],
            pluginsOpts: {
            [grapesJSMJML]: {/* ...options */}
            },
            storageManager: { type: 'simple-storage' },
            blockManager: {
                appendTo: '#blocks',
                blocks: [{
                    id: "body2",
                    lagel: "<b>body</b>",
                    attributes: { class:'gjs-block-section' },
                    content: `
                        <mjml>
                            <mj-body>
                                <mj-section>

                                </mj-section>
                            </mj-body>
                        </mjml>
                    `
                }, {
                    id: 'grid', // id is mandatory
                    label: '<b>grid</b>', // You can use HTML/SVG inside labels
                    attributes: { class:'gjs-block-section' },
                    content: `
                        <mj-section>
                            <mj-column>
                            <mj-image width="100px" src="https://mjml.io/assets/img/logo-small.png"></mj-image>
                            <mj-divider border-color="#F45E43"></mj-divider>
                            <mj-text font-size="20px" color="#F45E43" font-family="helvetica">Hello World</mj-text>
                            </mj-column>
                        </mj-section>
                    `
                }]
            },
        });

        // Here our `simple-storage` implementation
        const SimpleStorage = {};

        editor.StorageManager.add('simple-storage', {
            /**
             * Load the data
             * @param  {Array} keys Array containing values to load, eg, ['gjs-components', 'gjs-style', ...]
             * @param  {Function} clb Callback function to call when the load is ended
             * @param  {Function} clbErr Callback function to call in case of errors
             */
            load(keys, clb, clbErr) {
                const result = {};

                keys.forEach(key => {
                const value = SimpleStorage[key];
                if (value) {
                    result[key] = value;
                }
                });

                // Might be called inside some async method
                clb(result);
            },

            /**
             * Store the data
             * @param  {Object} data Data object to store
             * @param  {Function} clb Callback function to call when the load is ended
             * @param  {Function} clbErr Callback function to call in case of errors
             */
            store(data, clb, clbErr) {

                for (let key in data) {
                    SimpleStorage[key] = data[key];
                }
                // Might be called inside some async method
                clb();
            }
            
        });

        //editor.trigger("storage:start")

        var blockManager = editor.BlockManager;

        // 'my-first-block' is the ID of the block
        blockManager.add('my-first-block', {
            label: 'body',
            content: '<mjml><mj-body><mj-section></mj-section></mj-body></mjml>',
        });

    }
}
</script>
<template>
    <div class="columns is-variable is-0">
        <div class="column is-8">
            <div id="gjs">
                <mjml>
                    <mj-body>
                        <mj-section>
                            <mj-column>
                                <mj-text>My Company</mj-text>
                            </mj-column>
                        </mj-section>
                    </mj-body>
                </mjml>
            </div>
        </div>
        <div class="column is-4">
            <div id="blocks"></div>
        </div>
    </div>
</template>
