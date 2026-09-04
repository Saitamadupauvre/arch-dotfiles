import app from "ags/gtk4/app"
import { Astal } from "ags/gtk4"
import { Gdk } from "ags/gtk4"

import Workspaces from "./Workspaces"
import ClientTitle from "./ClientTitle"
import SysTray from "./Tray"
import Clock from "./Clock"
import Volume from "./Volume"
import NetworkIndicator from "./Network"
import Battery from "./Battery"
import SysInfo from "./SysInfo"

export default function Bar(gdkmonitor: Gdk.Monitor) {
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

  return (
    <window
      visible
      name="bar"
      class="Bar"
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={TOP | LEFT | RIGHT}
      marginTop={8}
      marginLeft={10}
      marginRight={10}
      application={app}
    >
      <centerbox cssName="centerbox">
        <box $type="start">
          <box cssName="module-group">
            <Workspaces />
          </box>
        </box>
        <box $type="center">
          <ClientTitle />
        </box>
        <box $type="end">
          <box cssName="module-group">
            <SysInfo />
            <NetworkIndicator />
            <Volume />
            <Battery />
            <Clock />
            <SysTray />
          </box>
        </box>
      </centerbox>
    </window>
  )
}
