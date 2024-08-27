// For every option, see ~/.config/ags/modules/.configuration/user_options.js
// (vscode users ctrl+click this: file://./modules/.configuration/user_options.js)
// (vim users: `:vsp` to split window, move cursor to this path, press `gf`. `Ctrl-w` twice to switch between)
//   options listed in this file will override the default ones in the above file

const userConfigOptions = {
    'apps': {
        'bluetooth': "blueman-manager",
        'imageViewer': "nomacs",
        'network': "nm-connection-editor",
        // 'settings': "XDG_CURRENT_DESKTOP=\"gnome\" gnome-control-center",
        'taskManager': "mission-center",
        'terminal': "kitty", // This is only for shell actions
    },
    'brightness': {
        // Object of controller names for each monitor, either "brightnessctl" or "ddcutil" or "auto"
        // 'default' one will be used if unspecified
        // Examples
        // 'eDP-1': "brightnessctl",
        // 'DP-1': "ddcutil",
        'controllers': {
            // 'default': "auto",
            'eDP-1': "brightnessctl",
            'DP-2': "ddcutil",
        },
    },
    'overview': {
        'scale': 0.18, // Relative to screen size
        'numOfRows': 2,
        'numOfCols': 5,
        'wsNumScale': 0.09,
        'wsNumMarginScale': 0.07,
    },
    'time': {
        // See https://docs.gtk.org/glib/method.DateTime.format.html
        // Here's the 12h format: "%I:%M%P"
        // For seconds, add "%S" and set interval to 1000
        'format': "%H:%M:%S",
        'interval': 1,
        'dateFormatLong': "%A, %d/%m", // On bar
        'dateInterval': 5000,
        'dateFormat': "%d/%m", // On notif time
    },
    'dock': {
        'enabled': false,
        'hiddenThickness': 25,
        'pinnedApps': ['librewolf', 'dolphin'],
        'layer': 'top',
        'monitorExclusivity': true, // Dock will move to other monitor along with focus if enabled
        'searchPinnedAppIcons': false, // Try to search for the correct icon if the app class isn't an icon name
        'trigger': ['client-added', 'client-removed'], // client_added, client_move, workspace_active, client_active
        // Automatically hide dock after `interval` ms since trigger
        'autoHide': [
            {
                'trigger': 'client-added',
                'interval': 500,
            },
            {
                'trigger': 'client-removed',
                'interval': 500,
            },
        ],
    },
}

export default userConfigOptions;
