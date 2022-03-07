import { TooltipContent, TooltipOptions } from '../types';
/**
 *
 * Tiny any beautiful tooltips module.
 *
 * Can be showed near passed Element with any specified HTML content
 *
 * https://github.com/codex-team/codex.tooltips <- ★ Star if you like it ( ͡° ͜ ͡°)
 *
 * @author CodeX <codex.so>
 * @licence MIT
 */
export default class Tooltip {
    /**
     * Tooltip CSS classes
     */
    private get CSS();
    /**
     * Module nodes
     */
    private nodes;
    /**
     * Appearance state
     */
    private showed;
    /**
     * Offset above the Tooltip
     */
    private offsetTop;
    /**
     * Offset at the left from the Tooltip
     */
    private offsetLeft;
    /**
     * Offset at the right from the Tooltip
     */
    private offsetRight;
    /**
     * Store timeout before showing to clear it on hide
     */
    private showingTimeout;
    /**
     * How many milliseconds need to wait before hiding
     */
    private hidingDelay;
    /**
     * Store timeout before hiding
     */
    private hidingTimeout;
    /**
     * Module constructor
     */
    constructor();
    /**
     * Show Tooltip near passed element with specified HTML content
     *
     * @param {HTMLElement} element - target element to place Tooltip near that
     * @param {TooltipContent} content — any HTML Element of String that will be used as content
     * @param {TooltipOptions} options — Available options {@link TooltipOptions}
     */
    show(element: HTMLElement, content: TooltipContent, options: TooltipOptions): void;
    /**
     * Hide toolbox tooltip and clean content
     * @param {boolean} skipDelay - forces hiding immediately
     */
    hide(skipDelay?: boolean): void;
    /**
     * Mouseover/Mouseleave decorator
     *
     * @param {HTMLElement} element - target element to place Tooltip near that
     * @param {TooltipContent} content — any HTML Element of String that will be used as content
     * @param {TooltipOptions} options — Available options {@link TooltipOptions}
     */
    onHover(element: any, content: any, options: any): void;
    /**
     * Release DOM and event listeners
     */
    destroy(): void;
    /**
     * Hide tooltip when page is scrolled
     */
    private handleWindowScroll;
    /**
     * Module Preparation method
     */
    private prepare;
    /**
     * Append CSS file
     */
    private loadStyles;
    /**
     * Calculates element coords and moves tooltip bottom of the element
     *
     * @param {HTMLElement} element
     * @param {TooltipOptions} showingOptions
     */
    private placeBottom;
    /**
     * Calculates element coords and moves tooltip top of the element
     *
     * @param {HTMLElement} element
     * @param {TooltipOptions} showingOptions
     */
    private placeTop;
    /**
     * Calculates element coords and moves tooltip left of the element
     *
     * @param {HTMLElement} element
     * @param {TooltipOptions} showingOptions
     */
    private placeLeft;
    /**
     * Calculates element coords and moves tooltip right of the element
     *
     * @param {HTMLElement} element
     * @param {TooltipOptions} showingOptions
     */
    private placeRight;
    /**
     * Set wrapper position
     */
    private applyPlacement;
    /**
     * Helper for making Elements with classname and attributes
     *
     * @param  {string} tagName           - new Element tag name
     * @param  {array|string} classNames  - list or name of CSS classname(s)
     * @param  {Object} attributes        - any attributes
     * @return {HTMLElement}
     */
    private make;
    /**
     * Append one or several elements to the parent
     *
     * @param  {Element|DocumentFragment} parent    - where to append
     * @param  {Element|Element[]} elements - element or elements list
     */
    private append;
    /**
     * Append element or a couple to the beginning of the parent elements
     *
     * @param {Element} parent - where to append
     * @param {Element|Element[]} elements - element or elements list
     */
    private prepend;
}
