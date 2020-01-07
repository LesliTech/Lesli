import './chunk-b91774bc.js';
import './helpers.js';
import './chunk-b76a6c1d.js';
import './chunk-3802ee87.js';
import { r as registerComponent, u as use } from './chunk-cca88db8.js';
import { P as Pagination, a as PaginationButton } from './chunk-22aff7fe.js';
export { P as BPagination, a as BPaginationButton } from './chunk-22aff7fe.js';

var Plugin = {
  install: function install(Vue) {
    registerComponent(Vue, Pagination);
    registerComponent(Vue, PaginationButton);
  }
};
use(Plugin);

export default Plugin;
