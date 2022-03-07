/**
 * Base options interface for tooltips
 */
export default interface TooltipOptions {
    /**
     * Tooltip placement: top|bottom|left|right
     */
    placement?: string;
    /**
     * Tooltip top margin
     */
    marginTop?: number;
    /**
     * Tooltip left margin
     */
    marginLeft?: number;
    /**
     * Tooltip right margin
     */
    marginRight?: number;
    /**
     * Tooltip bottom margin
     */
    marginBottom?: number;
    /**
     * Timout before showing
     */
    delay?: number;
    /**
     * Timout before hiding
     */
    hidingDelay?: number;
}
