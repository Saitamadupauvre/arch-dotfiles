import { Gtk } from "ags/gtk4"
import { createBinding } from "gnim"
import Hyprland from "gi://AstalHyprland"

export default function ClientTitle() {
  const hypr = Hyprland.get_default()
  const client = createBinding(hypr, "focusedClient")
  const title = client((c) => c?.title ?? "")

  return (
    <box cssName="client-title" halign={Gtk.Align.CENTER} hexpand>
      <label label={title((t) => (t ? `󰣇 ${t}` : ""))} maxWidthChars={50} ellipsize={3} />
    </box>
  )
}
