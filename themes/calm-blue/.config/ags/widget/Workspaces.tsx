import { Gtk } from "ags/gtk4"
import { createBinding, For } from "gnim" // eslint-disable-line
import Hyprland from "gi://AstalHyprland"

export default function Workspaces() {
  const hypr = Hyprland.get_default()
  const workspaces = createBinding(hypr, "workspaces").as((ws) =>
    [...ws].sort((a, b) => a.id - b.id),
  )
  const focused = createBinding(hypr, "focusedWorkspace")

  return (
    <box cssName="workspaces">
      <For each={workspaces}>
        {(ws) => (
          <button
            cssClasses={focused((f) => [
              "workspace",
              f?.id === ws.id ? "active" : "",
            ])}
            onClicked={() => ws.focus()}
          >
            <label label={String(ws.id)} />
          </button>
        )}
      </For>
    </box>
  )
}
