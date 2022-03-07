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
  private get CSS() {
    return {
      tooltip: 'ct',
      tooltipContent: 'ct__content',
      tooltipShown: 'ct--shown',
      placement: {
        left: 'ct--left',
        bottom: 'ct--bottom',
        right: 'ct--right',
        top: 'ct--top',
      },
    };
  }
  /**
   * Module nodes
   */
  private nodes: {
    wrapper: HTMLElement,
    content: HTMLElement,
  } = {
    wrapper: null,
    content: null,
  };

  /**
   * Appearance state
   */
  private showed: boolean = false;

  /**
   * Offset above the Tooltip
   */
  private offsetTop: number = 10;

  /**
   * Offset at the left from the Tooltip
   */
  private offsetLeft: number = 10;

  /**
   * Offset at the right from the Tooltip
   */
  private offsetRight: number = 10;

  /**
   * Store timeout before showing to clear it on hide
   */
  private showingTimeout;

  /**
   * How many milliseconds need to wait before hiding
   */
  private hidingDelay: number = 0;

  /**
   * Store timeout before hiding
   */
  private hidingTimeout;

  /**
   * Module constructor
   */
  constructor() {
    this.loadStyles();
    this.prepare();

    window.addEventListener('scroll', this.handleWindowScroll, {passive: true});
  }

  /**
   * Show Tooltip near passed element with specified HTML content
   *
   * @param {HTMLElement} element - target element to place Tooltip near that
   * @param {TooltipContent} content — any HTML Element of String that will be used as content
   * @param {TooltipOptions} options — Available options {@link TooltipOptions}
   */
  public show(element: HTMLElement, content: TooltipContent, options: TooltipOptions): void {
    if (!this.nodes.wrapper) {
      this.prepare();
    }

    if (this.hidingTimeout) {
      clearTimeout(this.hidingTimeout);
    }

    const basicOptions = {
      placement: 'bottom',
      marginTop: 0,
      marginLeft: 0,
      marginRight: 0,
      marginBottom: 0,
      delay: 70,
      hidingDelay: 0,
    };
    const showingOptions = Object.assign(basicOptions, options);

    if (showingOptions.hidingDelay) {
      this.hidingDelay = showingOptions.hidingDelay;
    }

    this.nodes.content.innerHTML = '';

    if (typeof content === 'string') {
      this.nodes.content.appendChild(document.createTextNode(content));
    } else if (content instanceof Node) {
      this.nodes.content.appendChild(content);
    } else {
      throw Error('[CodeX Tooltip] Wrong type of «content» passed. It should be an instance of Node or String. ' +
        'But ' + typeof content + ' given.');
    }

    this.nodes.wrapper.classList.remove(...Object.values(this.CSS.placement));

    switch (showingOptions.placement) {
      case 'top':
        this.placeTop(element, showingOptions);
        break;

      case 'left':
        this.placeLeft(element, showingOptions);
        break;

      case 'right':
        this.placeRight(element, showingOptions);
        break;

      case 'bottom':
      default:
        this.placeBottom(element, showingOptions);
        break;
    }

    if (showingOptions && showingOptions.delay) {
      this.showingTimeout = setTimeout(() => {
        this.nodes.wrapper.classList.add(this.CSS.tooltipShown);
        this.showed = true;
      }, showingOptions.delay);
    } else {
      this.nodes.wrapper.classList.add(this.CSS.tooltipShown);
      this.showed = true;
    }
  }

  /**
   * Hide toolbox tooltip and clean content
   * @param {boolean} skipDelay - forces hiding immediately
   */
  public hide(skipDelay: boolean = false): void {
    if (this.hidingDelay && !skipDelay) {
      // debounce
      if (this.hidingTimeout) {
        clearTimeout(this.hidingTimeout);
      }

      this.hidingTimeout = setTimeout(() => {
        this.hide(true);
      }, this.hidingDelay);

      return;
    }

    this.nodes.wrapper.classList.remove(this.CSS.tooltipShown);
    this.showed = false;

    if (this.showingTimeout) {
      clearTimeout(this.showingTimeout);
    }
  }

  /**
   * Mouseover/Mouseleave decorator
   *
   * @param {HTMLElement} element - target element to place Tooltip near that
   * @param {TooltipContent} content — any HTML Element of String that will be used as content
   * @param {TooltipOptions} options — Available options {@link TooltipOptions}
   */
  public onHover(element, content, options): void {
    element.addEventListener('mouseenter', () => {
      this.show(element, content, options);
    });
    element.addEventListener('mouseleave', () => {
      this.hide();
    });
  }

  /**
   * Release DOM and event listeners
   */
  public destroy(): void {
    this.nodes.wrapper.remove();

    window.removeEventListener('scroll', this.handleWindowScroll);
  }

  /**
   * Hide tooltip when page is scrolled
   */
  private handleWindowScroll = () => {
    if (this.showed) {
      this.hide(true);
    }
  }

  /**
   * Module Preparation method
   */
  private prepare(): void {
    this.nodes.wrapper = this.make('div', this.CSS.tooltip);
    this.nodes.content = this.make('div', this.CSS.tooltipContent);

    this.append(this.nodes.wrapper, this.nodes.content);
    this.append(document.body, this.nodes.wrapper);
  }

  /**
   * Append CSS file
   */
  private loadStyles(): void {
    const id = 'codex-tooltips-style';

    if (document.getElementById(id)) {
      return;
    }

    const styles = require('../styles/main.css');
    const tag = this.make('style', null, {
      textContent: styles.toString(),
      id,
    });

    /**
     * Append styles at the top of HEAD tag
     */
    this.prepend(document.head, tag);
  }

  /**
   * Calculates element coords and moves tooltip bottom of the element
   *
   * @param {HTMLElement} element
   * @param {TooltipOptions} showingOptions
   */
  private placeBottom(element: HTMLElement, showingOptions: TooltipOptions): void {
    const elementCoords = element.getBoundingClientRect();
    const left = elementCoords.left + element.clientWidth / 2 - this.nodes.wrapper.offsetWidth / 2;
    const top = elementCoords.bottom + window.pageYOffset + this.offsetTop + showingOptions.marginTop;

    this.applyPlacement('bottom', left, top);
  }

  /**
   * Calculates element coords and moves tooltip top of the element
   *
   * @param {HTMLElement} element
   * @param {TooltipOptions} showingOptions
   */
  private placeTop(element: HTMLElement, showingOptions: TooltipOptions): void {
    const elementCoords = element.getBoundingClientRect();
    const left = elementCoords.left + element.clientWidth / 2 - this.nodes.wrapper.offsetWidth / 2;
    const top = elementCoords.top + window.pageYOffset - this.nodes.wrapper.clientHeight - this.offsetTop;

    this.applyPlacement('top', left, top);
  }

  /**
   * Calculates element coords and moves tooltip left of the element
   *
   * @param {HTMLElement} element
   * @param {TooltipOptions} showingOptions
   */
  private placeLeft(element: HTMLElement, showingOptions: TooltipOptions): void {
    const elementCoords = element.getBoundingClientRect();
    const left = elementCoords.left - this.nodes.wrapper.offsetWidth - this.offsetLeft - showingOptions.marginLeft;
    const top = elementCoords.top + window.pageYOffset + element.clientHeight / 2 - this.nodes.wrapper.offsetHeight / 2;

    this.applyPlacement('left', left, top);
  }

  /**
   * Calculates element coords and moves tooltip right of the element
   *
   * @param {HTMLElement} element
   * @param {TooltipOptions} showingOptions
   */
  private placeRight(element: HTMLElement, showingOptions: TooltipOptions): void {
    const elementCoords = element.getBoundingClientRect();
    const left = elementCoords.right + this.offsetRight + showingOptions.marginRight;
    const top = elementCoords.top + window.pageYOffset + element.clientHeight / 2 - this.nodes.wrapper.offsetHeight / 2;

    this.applyPlacement('right', left, top);
  }

  /**
   * Set wrapper position
   */
  private applyPlacement(place: string, left: number, top: number): void {
    this.nodes.wrapper.classList.add(this.CSS.placement[place]);

    this.nodes.wrapper.style.left = `${left}px`;
    this.nodes.wrapper.style.top = `${top}px`;
  }

  /**
   * Helper for making Elements with classname and attributes
   *
   * @param  {string} tagName           - new Element tag name
   * @param  {array|string} classNames  - list or name of CSS classname(s)
   * @param  {Object} attributes        - any attributes
   * @return {HTMLElement}
   */
  private make(tagName: string, classNames: string|string[] = null, attributes: object = {}): HTMLElement {
    const el = document.createElement(tagName);

    if ( Array.isArray(classNames) ) {
      el.classList.add(...classNames);
    } else if ( classNames ) {
      el.classList.add(classNames);
    }

    for (const attrName in attributes) {
      if (attributes.hasOwnProperty(attrName)) {
        el[attrName] = attributes[attrName];
      }
    }

    return el;
  }

  /**
   * Append one or several elements to the parent
   *
   * @param  {Element|DocumentFragment} parent    - where to append
   * @param  {Element|Element[]} elements - element or elements list
   */
  private append(parent: Element|DocumentFragment, elements: Element|Element[]|DocumentFragment): void {
    if ( Array.isArray(elements) ) {
      elements.forEach( (el) => parent.appendChild(el) );
    } else {
      parent.appendChild(elements);
    }
  }

  /**
   * Append element or a couple to the beginning of the parent elements
   *
   * @param {Element} parent - where to append
   * @param {Element|Element[]} elements - element or elements list
   */
  private prepend(parent: Element, elements: Element|Element[]): void {
    if ( Array.isArray(elements) ) {
      elements = elements.reverse();
      elements.forEach( (el) => parent.prepend(el) );
    } else {
      parent.prepend(elements);
    }
  }
}
