import { createPoll } from "ags/time"
import { execAsync } from "ags/process"
import { Gtk } from "ags/gtk4"
import { For } from "gnim"
import GLib from "gi://GLib"

function readCpu() {
  const stat = GLib.file_get_contents("/proc/stat")[1]
  const line = new TextDecoder().decode(stat).split("\n")[0]
  const parts = line.trim().split(/\s+/).slice(1).map(Number)
  const idle = parts[3]
  const total = parts.reduce((a, b) => a + b, 0)
  return { idle, total }
}

let prev = readCpu()

function cpuPercent() {
  const cur = readCpu()
  const idleDelta = cur.idle - prev.idle
  const totalDelta = cur.total - prev.total
  prev = cur
  if (totalDelta <= 0) return 0
  return Math.round((1 - idleDelta / totalDelta) * 100)
}

function memStats() {
  const meminfo = new TextDecoder().decode(GLib.file_get_contents("/proc/meminfo")[1])
  const total = Number(meminfo.match(/MemTotal:\s+(\d+)/)?.[1] ?? 1)
  const avail = Number(meminfo.match(/MemAvailable:\s+(\d+)/)?.[1] ?? 0)
  const usedGb = (total - avail) / 1024 / 1024
  const totalGb = total / 1024 / 1024
  return { percent: Math.round((1 - avail / total) * 100), usedGb, totalGb }
}

async function topProcesses() {
  const out = await execAsync(["bash", "-c", "ps -eo comm,%cpu --sort=-%cpu --no-headers | head -5"])
  return out
    .trim()
    .split("\n")
    .map((line) => {
      const idx = line.lastIndexOf(" ")
      return { name: line.slice(0, idx).trim(), cpu: line.slice(idx).trim() }
    })
}

export default function SysInfo() {
  const cpu = createPoll(0, 3000, cpuPercent)
  const mem = createPoll({ percent: 0, usedGb: 0, totalGb: 0 }, 5000, memStats)
  const procs = createPoll<{ name: string; cpu: string }[]>([], 3000, topProcesses)

  const openBtop = () => execAsync(["kitty", "-e", "btop"])

  return (
    <box cssName="sysinfo">
      <menubutton>
        <label label={cpu((v) => `󰍛 ${v}%`)} />
        <popover>
          <box cssName="sysinfo-popover" orientation={Gtk.Orientation.VERTICAL} spacing={6}>
            <label label="System" cssName="popover-section" halign={Gtk.Align.START} />
            <label label={cpu((v) => `CPU  ${v}%`)} halign={Gtk.Align.START} />
            <label
              label={mem((m) => `RAM  ${m.usedGb.toFixed(1)} / ${m.totalGb.toFixed(1)} GB`)}
              halign={Gtk.Align.START}
            />
            <label label="Top processes" cssName="popover-section" halign={Gtk.Align.START} />
            <box orientation={Gtk.Orientation.VERTICAL} spacing={2}>
              <For each={procs}>
                {(p) => (
                  <box spacing={8}>
                    <label label={p.name} hexpand halign={Gtk.Align.START} />
                    <label label={`${p.cpu}%`} cssName="popover-dim" />
                  </box>
                )}
              </For>
            </box>
            <button cssName="popover-more" onClicked={openBtop}>
              <label label="Open btop" />
            </button>
          </box>
        </popover>
      </menubutton>
      <label label={mem((m) => `󰾆 ${m.percent}%`)} />
    </box>
  )
}
