import { createBinding, createComputed } from "gnim"
import { Gtk } from "ags/gtk4"
import Wp from "gi://AstalWp"

export default function Volume() {
  const wp = Wp.get_default()
  const speaker = wp?.audio?.defaultSpeaker

  if (!speaker) return <box cssName="volume" />

  const volume = createBinding(speaker, "volume")
  const muted = createBinding(speaker, "mute")

  const icon = createComputed(() => {
    const v = volume()
    const m = muted()
    return m || v === 0 ? "󰝟" : v > 0.66 ? "󰕾" : v > 0.33 ? "󰖀" : "󰕿"
  })

  const attachScroll = (self: Gtk.Widget) => {
    const scroll = new Gtk.EventControllerScroll({
      flags: Gtk.EventControllerScrollFlags.VERTICAL,
    })
    scroll.connect("scroll", (_ctl, _dx, dy) => {
      speaker.volume = Math.max(0, Math.min(1, speaker.volume - dy * 0.05))
    })
    self.add_controller(scroll)
  }

  return (
    <menubutton cssName="volume" $={attachScroll}>
      <box>
        <label label={icon as any} />
        <label label={volume((v) => ` ${Math.round(v * 100)}%`)} />
      </box>
      <popover>
        <box cssName="volume-popover" orientation={Gtk.Orientation.VERTICAL} spacing={8}>
          <box spacing={8}>
            <button cssName="popover-icon-btn" onClicked={() => (speaker.mute = !speaker.mute)}>
              <label label={icon as any} />
            </button>
            <slider
              hexpand
              min={0}
              max={1}
              value={volume}
              onChangeValue={(_self, _scroll, value) => {
                speaker.volume = value
                return true
              }}
            />
          </box>
          <label label="Output" cssName="popover-section" halign={Gtk.Align.START} />
        </box>
      </popover>
    </menubutton>
  )
}
