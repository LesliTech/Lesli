import Vue from 'vue';
import { NormalizedScopedSlot } from 'vue/types/vnode';
import { PluginDef } from '@fullcalendar/core';
export declare function wrapVDomGenerator(vDomGenerator: NormalizedScopedSlot): (props: any) => {
    vue: import("vue/types/vnode").ScopedSlotChildren;
};
export declare function createVueContentTypePlugin(parent: Vue): PluginDef;
