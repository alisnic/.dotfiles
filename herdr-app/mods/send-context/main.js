import { View, div } from "gpui-kit";
import { appHome, exec, focused, nextCommand, notify, run } from "herdr";

export default class SendContext extends View {
  init(_props, cx) {
    cx.spawn(async (cx) => {
      for (;;) {
        if (await nextCommand() !== "send") continue;

        const source = focused();
        if (!source?.pane || !source.terminal) {
          notify({ title: "No active terminal pane", level: "warning" });
          continue;
        }

        // Clear old text so a failed copy cannot paste the previous context.
        const previous = cx.read_from_clipboard();
        cx.write_to_clipboard("");
        const result = await exec("python3", [`${appHome()}/mods/send-context/send-keys.py`, source.terminal]);
        if (result.code !== 0) {
          if (!cx.read_from_clipboard() && previous) cx.write_to_clipboard(previous);
          notify({ title: "Could not copy file context", body: result.stderr, level: "error" });
          continue;
        }

        cx.timer.after(200, (cx) => {
          if (!cx.read_from_clipboard()) {
            if (previous) cx.write_to_clipboard(previous);
            notify({ title: "No new file context", body: "Neovim did not copy file context", level: "warning" });
            return;
          }
          if (focused()?.pane !== source.pane) return;

          run("pane.go", { direction: "left" });
          cx.timer.after(50, () => {
            const target = focused();
            if (!target?.pane || target.pane === source.pane || !target.terminal) {
              if (target?.pane && target.pane !== source.pane) run("pane.focus", { pane: source.pane });
              notify({ title: "No terminal pane to the left", level: "warning" });
              return;
            }

            run("terminal.paste");
          });
        });
      }
    });
  }

  render() {
    return div();
  }
}
