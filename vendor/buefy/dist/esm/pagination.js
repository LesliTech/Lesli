import './chunk-1fafdf15.js';
import './helpers.js';
import './chunk-ce068f0a.js';
import './chunk-4139443a.js';
import { r as registerComponent, u as use } from './chunk-cca88db8.js';
import { P as Pagination, a as PaginationButton } from './chunk-c5c83375.js';
export { P as BPagination, a as BPaginationButton } from './chunk-c5c83375.js';

var Plugin = {
  install: function install(Vue) {
    registerComponent(Vue, Pagination);
    registerComponent(Vue, PaginationButton);
  }
};
use(Plugin);

export default Plugin;
