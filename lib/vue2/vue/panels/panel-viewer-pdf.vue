<script>
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


// ·
export default {
    data() {
        return {
            translations: {
                notifications: I18n.t("bell.notifications")
            },
            open: false,
            loading: false,
            pdf: null, 
            pageNum: 1,
            pageRendering:false,
            pageNumPending: null,
            pdfNumPages: 0,
            canvas: null,
            context: null,
            document: {}
        }
    },
    mounted() {
        this.data.global.showPanelViewerPdf = this.showPanelViewerPdf
    },
    methods: {

        showPanelViewerPdf(name, url) {
            this.document = { name, url }
            this.loading = true
            if (!this.document.name || !this.document.url) { return this.open = false; }
            this.open = true
            this.renderPdf()
        },

        renderPdf() {

            // Loaded via <script> tag, create shortcut to access PDF.js exports.
            var pdfjsLib = window['pdfjs-dist/build/pdf'];

            // The workerSrc property shall be specified.
            pdfjsLib.GlobalWorkerOptions.workerSrc = '/javascripts/pdf.worker.js';

            // Asynchronous download of PDF
            var loadingTask = pdfjsLib.getDocument(this.document.url);

            // resolve the promise, save the pdf object in a global property invoke 
            // the render page method, to show the user the first page of the pdf 
            loadingTask.promise.then(pdf => {
                this.pdf = pdf
                this.pdfNumPages = pdf.numPages
                this.renderPage()
            })

        },

        renderPage(num = 1) {

            this.pageNum=num
            this.pageRendering=true

            this.pdf.getPage(num).then(page => {

                var scale = 5;
                var viewport = page.getViewport({ scale: scale });

                // Prepare canvas using PDF page dimensions
                this.canvas = this.$refs.canvaspanelviewerpdf
                this.context = this.canvas.getContext('2d');
                this.canvas.height = viewport.height;
                this.canvas.width = viewport.width;

                // Render PDF page into canvas context and return
                // the page render promise to avoid callback hell ^_^
                return page.render({
                    canvasContext: this.context,
                    viewport: viewport
                }).promise
                
            }).then(() => {

                // pdf page rendered successfully
                this.loading = false
                this.pageRendering = false
            });
        },

        // If another page rendering in progress, waits until the rendering is
        // finised. Otherwise, executes rendering immediately.
        queueRenderPage(num) {

            if (this.pageRendering) {
                this.pageNumPending = num;
                return 
            } 

            this.renderPage(num);

        },

        // Displays next page.
        nextPage() {
            if (this.pageNum >= this.pdfNumPages) {
                return;
            }

            this.queueRenderPage((this.pageNum+1));
        },


        // Displays previous page
        prevPage() {

            if (this.pageNum <= 1) {
                return;
            }

            this.queueRenderPage((this.pageNum-1));

        },

        closePanel() {

            if (this.context) {
                this.context.clearRect(0, 0, this.canvas.width, this.canvas.height);
            }

            this.loading = false,
            this.pdf = null, 
            this.pageNum = 1,
            this.pageNumPending = null,
            this.pdfNumPages = 0,
            this.canvas = null,
            this.context = null,
            this.document = {}
        }
    }
}
</script>
<template>
    <b-sidebar
        class="application-panel-viewer-pdf"
        :open.sync="open"
        :right="true"
        :fullheight="true"
        :overlay="true"
        :on-cancel="closePanel">
        <div class="panel-title is-size-5">
            <h4>{{ document.name }}</h4>
            <span class="icon is-large hover" @click="open = false">
                <i class="fas fa-lg fa-chevron-right"></i>
            </span>
        </div>
        
        <div v-show="pdfNumPages > 1" class="has-text-centered p-2 box">
            <button @click="prevPage" class="button">Prev page</button>
            <button class="button is-white">{{ pageNum }}/{{ pdfNumPages }}</button>
            <button @click="nextPage" class="button">Next page</button>
        </div>
        
        <div class="p-4">
            <component-data-loading v-if="loading"></component-data-loading>
            <canvas ref="canvaspanelviewerpdf"></canvas>
        </div>
    </b-sidebar>
</template>
<style>
iframe {
    display: block;
    width: 100%;
    height: 100%;
}
</style>
