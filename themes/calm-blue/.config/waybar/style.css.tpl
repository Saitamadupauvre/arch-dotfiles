* {
    border: none;
    border-radius: 0;
    font-family: JetBrainsMono Nerd Font, monospace;
    font-weight: bold;
    font-size: 14px;
    min-height: 0;
}

window#waybar {
    background: rgba(0, 0, 0, 0);
    color: #{{FG0}};
}

#workspaces button {
    padding: 5px;
    color: #{{FG3}};
    margin-right: 5px;
}

#workspaces button.active {
    color: #{{BG0}};
    background: #{{ACCENT}};
    border-radius: 10px;
}

#workspaces button.focused {
    color: #{{BG0}};
    background: #{{ACCENT}};
    border-radius: 10px;
}

#workspaces button.urgent {
    color: #{{BG0}};
    background: #{{ACCENT}};
    border-radius: 10px;
}

#workspaces button:hover {
    background-color: rgba({{ACCENT2_RGB}}, 0.35);
    color: #{{FG0}};
    border: 1px solid #{{ACCENT2}};
    border-radius: 10px;
}

#window,
#clock,
#battery,
#pulseaudio,
#network,
#cpu,
#memory,
#workspaces,
#tray,
#backlight {
    background-color: rgba({{BG1_RGB}}, 0.5);
    padding: 0px 10px;
    margin: 3px 0px;
    margin-top: 5px;
}

#backlight {
    border-radius: 10px 0px 0px 10px;
}

#tray {
    border-radius: 10px;
    margin-right: 10px;
}

#workspaces {
    background-color: rgba({{BG1_RGB}}, 0.5);
    border-radius: 10px;
    margin-left: 10px;
    padding-right: 0px;
    padding-left: 5px;
}

#cpu {
    border-radius: 0px 10px 10px 0px;
    margin-right: 10px;
}

#memory {
    border-radius: 10px 0px 0px 10px;
}

#window {
    border-radius: 10px;
    margin-left: 60px;
    margin-right: 60px;
}

#clock {
    color: #{{FG0}};
    border-radius: 10px 10px 10px 10px;
    margin-left: 5px;
    border-right: 0px;
}

#network {
    color: #{{ACCENT2}};
    border-radius: 10px 0px 0px 10px;
}

#pulseaudio {
    color: #{{FG0}};
    border-left: 0px;
    border-right: 0px;
}

#pulseaudio.microphone {
    color: #{{FG0}};
    border-radius: 0px 10px 10px 0px;
    border-left: 0px;
    border-right: 0px;
    margin-right: 5px;
}

#battery {
    color: #{{FG0}};
    border-radius: 0px 10px 10px 0px;
    margin-right: 10px;
}
