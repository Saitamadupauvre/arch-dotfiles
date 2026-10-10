import { Gtk } from "ags/gtk4"
import { createPoll } from "ags/time"

export default function Clock() {
  const time = createPoll("", 1000, "date '+%H:%M'")

  return (
    <menubutton cssName="clock" halign={Gtk.Align.CENTER}>
      <label label={time} />
      <popover>
        <Gtk.Calendar />
      </popover>
    </menubutton>
  )
}
