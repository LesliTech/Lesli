import './chunk-1fafdf15.js';
import './helpers.js';
import './chunk-6985c8ce.js';
import './chunk-cdfca85b.js';
import { r as registerComponent, u as use } from './chunk-cca88db8.js';
import { P as Pagination, a as PaginationButton } from './chunk-bd608559.js';
export { P as BPagination, a as BPaginationButton } from './chunk-bd608559.js';

var Plugin = {
  install: function install(Vue) {
    registerComponent(Vue, Pagination);
    registerComponent(Vue, PaginationButton);
  }
};
use(Plugin);

export default Plugin;
