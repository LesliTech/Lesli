import './chunk-6ea13200.js';
import './helpers.js';
import './chunk-17222463.js';
import './chunk-bed9f769.js';
import { r as registerComponent, u as use } from './chunk-cca88db8.js';
import { P as Pagination, a as PaginationButton } from './chunk-2772e167.js';
export { P as BPagination, a as BPaginationButton } from './chunk-2772e167.js';

var Plugin = {
  install: function install(Vue) {
    registerComponent(Vue, Pagination);
    registerComponent(Vue, PaginationButton);
  }
};
use(Plugin);

export default Plugin;
