import { template } from 'underscore';
import Backbone from 'backbone';

export default Backbone.View.extend({
  template: template(`
    <div class="<%= ppfx %>device-label"><%= deviceLabel %></div>
    <div class="<%= ppfx %>field <%= ppfx %>select">
      <span id="<%= ppfx %>input-holder">
        <select class="<%= ppfx %>devices"></select>
      </span>
      <div class="<%= ppfx %>sel-arrow">
        <div class="<%= ppfx %>d-s-arrow"></div>
      </div>
    </div>
    <button style="display:none" class="<%= ppfx %>add-trasp">+</button>`),

  events: {
    change: 'updateDevice'
  },

  initialize(o) {
    this.config = o.config || {};
    this.em = this.config.em;
    this.ppfx = this.config.pStylePrefix || '';
    this.events['click .' + this.ppfx + 'add-trasp'] = this.startAdd;
    this.listenTo(this.em, 'change:device', this.updateSelect);
    this.delegateEvents();
  },

  /**
   * Start adding new device
   * @return {[type]} [description]
   * @private
   */
  startAdd() {},

  /**
   * Update device of the editor
   * @private
   */
  updateDevice() {
    var em = this.em;
    if (em) {
      var devEl = this.devicesEl;
      var val = devEl ? devEl.val() : '';
      em.set('device', val);
    }
  },

  /**
   * Update select value on device update
   * @private
   */
  updateSelect() {
    var em = this.em;
    var devEl = this.devicesEl;
    if (em && em.getDeviceModel && devEl) {
      var device = em.getDeviceModel();
      var name = device ? device.get('name') : '';
      devEl.val(name);
    }
  },

  /**
   * Return devices options
   * @return {string} String of options
   * @private
   */
  getOptions() {
    const { collection, em } = this;
    let result = '';

    collection.each(device => {
      const { name, id } = device.attributes;
      const label = (em && em.t && em.t(`deviceManager.devices.${id}`)) || name;
      result += `<option value="${name}">${label}</option>`;
    });

    return result;
  },

  render() {
    const { em, ppfx, $el, el } = this;
    $el.html(
      this.template({
        ppfx,
        deviceLabel: em && em.t && em.t('deviceManager.device')
      })
    );
    this.devicesEl = $el.find(`.${ppfx}devices`);
    this.devicesEl.append(this.getOptions());
    el.className = `${ppfx}devices-c`;
    return this;
  }
});
