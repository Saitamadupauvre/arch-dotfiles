import { createBinding, For } from "gnim"
import Tray from "gi://AstalTray"

export default function SysTray() {
  const tray = Tray.get_default()
  const items = createBinding(tray, "items")

  return (
    <box cssName="tray">
      <For each={items}>
        {(item) => (
          <menubutton
            tooltipMarkup={createBinding(item, "tooltipMarkup")}
            menuModel={createBinding(item, "menuModel")}
            $={(self) => {
              self.insert_action_group("dbusmenu", item.actionGroup)
            }}
          >
            <image gicon={createBinding(item, "gicon")} />
          </menubutton>
        )}
      </For>
    </box>
  )
}
