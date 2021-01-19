export default {
  run(ed) {
    this.toggleVis(ed);
  },

  stop(ed) {
    this.toggleVis(ed, 0);
  },

  toggleVis(ed, active = 1) {
    if (!ed.Commands.isActive('preview')) {
      const method = active ? 'add' : 'remove';

      ed.Canvas.getFrames().forEach(frame => {
        frame.view.getBody().classList[method](`${this.ppfx}dashed`);
      });
    }
  }
};
