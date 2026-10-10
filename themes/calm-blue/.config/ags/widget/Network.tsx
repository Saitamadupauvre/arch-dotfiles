import { createBinding, createComputed, For, With } from "gnim"
import { Gtk } from "ags/gtk4"
import { execAsync } from "ags/process"
import Network from "gi://AstalNetwork"

export default function NetworkIndicator() {
  const network = Network.get_default()
  const wifi = createBinding(network, "wifi")
  const wired = createBinding(network, "wired")
  const primary = createBinding(network, "primary")

  const icon = createComputed(() => {
    const p = primary()
    const w = wifi()
    const e = wired()
    if (p === Network.Primary.WIRED && e) return "󰈀"
    if (w) return w.strength > 66 ? "󰤨" : w.strength > 33 ? "󰤢" : "󰤟"
    return "󰖪"
  })

  return (
    <menubutton
      cssName="network"
      $={(self) => {
        self.connect("notify::active", () => {
          if (self.active) network.wifi?.scan()
        })
      }}
    >
      <label label={icon} />
      <popover>
        <box cssName="network-popover" orientation={Gtk.Orientation.VERTICAL} spacing={4}>
          <box spacing={8}>
            <label label="Wi-Fi" cssName="popover-section" hexpand halign={Gtk.Align.START} />
            <switch
              active={wifi((w) => !!w?.enabled)}
              onStateSet={(_self, state) => {
                if (network.wifi) network.wifi.enabled = state
                return false
              }}
            />
          </box>
          <With value={wifi}>
            {(w) =>
              w ? (
                <box orientation={Gtk.Orientation.VERTICAL} spacing={2}>
                  <For each={createBinding(w, "accessPoints")}>
                    {(ap) => (
                      <button
                        cssName="ap-row"
                        onClicked={() =>
                          execAsync(["nmcli", "device", "wifi", "connect", ap.ssid ?? ""]).catch(
                            () => execAsync("nm-connection-editor"),
                          )
                        }
                      >
                        <box spacing={8}>
                          <label label={ap.strength > 66 ? "󰤨" : ap.strength > 33 ? "󰤢" : "󰤟"} />
                          <label label={ap.ssid ?? "Unknown"} hexpand halign={Gtk.Align.START} />
                        </box>
                      </button>
                    )}
                  </For>
                </box>
              ) : (
                <label label="Wi-Fi unavailable" cssName="popover-empty" />
              )
            }
          </With>
          <button cssName="popover-more" onClicked={() => execAsync("nm-connection-editor")}>
            <label label="Network settings" />
          </button>
        </box>
      </popover>
    </menubutton>
  )
}
