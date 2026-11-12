import { View, div } from "gpui-kit";
import { closeOverlay, focused, openOverlay, panes, props, run, spaces } from "herdr";

export default class ConfirmTabClose extends View {
  init() {
    const given = props() ?? {};
    const id = given.tab ?? focused()?.tab;
    const tab = spaces().flatMap(space => space.tabs).find(tab => tab.id === id);
    if (given.overlay) closeOverlay(given.overlay);
    if (!tab) return;

    const programs = panes()
      .filter(pane => pane.tab === id && pane.terminal && !pane.program?.shell)
      .map(pane => pane.program?.name || pane.title || "Unknown program");

    if (!programs.length) {
      run("tab.close", { id });
      return;
    }

    openOverlay({
      mod: "confirm",
      kind: "dialog",
      modal: true,
      width: 460,
      height: 210,
      props: {
        title: `Close tab "${tab.name}"?`,
        detail: `Running programs: ${[...new Set(programs)].join(", ")}.\nClosing this tab will stop them. Unsaved work can be lost.`,
        command: { name: "tab.close", args: { id, confirmed: true } },
      },
    });
  }

  render() {
    return div();
  }
}
