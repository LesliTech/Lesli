import './chunk-9e3207cc.js';
import { r as registerComponent, u as use } from './chunk-cca88db8.js';
import { D as Dropdown, a as DropdownItem } from './chunk-00e3e67f.js';
export { D as Dropdown, a as DropdownItem } from './chunk-00e3e67f.js';

var Plugin = {
  install: function install(Vue) {
    registerComponent(Vue, Dropdown);
    registerComponent(Vue, DropdownItem);
  }
};
use(Plugin);

export default Plugin;
