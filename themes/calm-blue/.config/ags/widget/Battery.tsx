import { createBinding, createComputed } from "gnim"
import { Gtk } from "ags/gtk4"
import AstalBattery from "gi://AstalBattery"

const ICONS = ["󰂃", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]

function fmtTime(seconds: number) {
  if (!seconds || seconds <= 0) return "—"
  const h = Math.floor(seconds / 3600)
  const m = Math.round((seconds % 3600) / 60)
  return h > 0 ? `${h}h ${m}m` : `${m}m`
}

export default function Battery() {
  const bat = AstalBattery.get_default()

  if (!bat.isPresent) return <box cssName="battery" />

  const percentage = createBinding(bat, "percentage")
  const charging = createBinding(bat, "charging")
  const timeToEmpty = createBinding(bat, "timeToEmpty")
  const timeToFull = createBinding(bat, "timeToFull")
  const energyRate = createBinding(bat, "energyRate")

  const icon = createComputed(() => {
    if (charging()) return "󰂄"
    return ICONS[Math.min(ICONS.length - 1, Math.floor(percentage() * 10))]
  })

  return (
    <menubutton cssName="battery">
      <box>
        <label label={icon} />
        <label label={percentage((p) => ` ${Math.round(p * 100)}%`)} />
      </box>
      <popover>
        <box cssName="battery-popover" orientation={Gtk.Orientation.VERTICAL} spacing={4}>
          <label label="Battery" cssName="popover-section" halign={Gtk.Align.START} />
          <box spacing={8}>
            <label label={icon} />
            <label label={percentage((p) => `${Math.round(p * 100)}%`)} hexpand halign={Gtk.Align.START} />
          </box>
          <label
            halign={Gtk.Align.START}
            label={createComputed(() =>
              charging() ? `Full in ${fmtTime(timeToFull())}` : `${fmtTime(timeToEmpty())} remaining`,
            )}
          />
          <label
            halign={Gtk.Align.START}
            cssName="popover-dim"
            label={energyRate((r) => `${r.toFixed(1)} W`)}
          />
        </box>
      </popover>
    </menubutton>
  )
}
