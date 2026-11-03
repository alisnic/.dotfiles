import { View, div } from "gpui-kit";
import { layout, run, spaces } from "herdr";

export default class AutoHideTabs extends View {
  init(_props, cx) {
    cx.timer.every(250, () => {
      const tabs = layout()?.children?.find(node => node.id === "work")?.children?.find(node => node.id === "tabs");
      const space = spaces().find(space => space.active);
      if (!tabs || !space) return;

      const hidden = space.tabs.length <= 1;
      if (Boolean(tabs.hidden) !== hidden) run(hidden ? "layout.hide" : "layout.show", { id: "tabs" });
    });
  }

  render() {
    return div();
  }
}
