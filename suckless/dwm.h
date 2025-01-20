/* See LICENSE file for copyright and license details. */

#include <X11/XF86keysym.h>

static const unsigned int borderpx = 4; // border pixel of windows
static const unsigned int snap = 32;    // snap pixel
static const int showbar = 1;           // 0 means no bar
static const int topbar = 1;            // 0 means bottom bar
static const char *fonts[] = {"Source Code Pro:size=16"};
static const char dmenufont[] = "Source Code Pro:size=16";

static const char white[] = "#ffffff";
static const char black[] = "#000000";
static const char gray[] = "#bbbbbb";
static const char black_cyan[] = "#003e3e";
static const char dark_cyan[] = "#007c7c";
static const char cyan[] = "#00baba";
static const char light_cyan[] = "#00f8f8";

static const char *colors[][3] = {
    // fg bg border
    [SchemeNorm] = {gray, black, black_cyan},
    [SchemeSel] = {white, black, cyan},
};

static const char *tags[] = {"1", "2", "3", "4", "5", "6", "7"};

static const Rule rules[] = {
// class instance title tags_mask isfloating monitor
#if 0
    {"Gimp", NULL, NULL, 0, 1, -1},
    {"Firefox", NULL, NULL, 1 << 8, 0, -1},
#endif
};

// layout(s)
static const float mfact = 0.55;     /* factor of master area size [0.05..0.95] */
static const int nmaster = 1;        /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
    // symbol arrange_function
    // first entry is default
    // no layout function means floating behavior
    {"[]=", tile},
    {"><>", NULL},
    {"[M]", monocle},
};

#define MODKEY Mod4Mask
#define TAGKEYS(KEY, TAG)                                                                          \
  {MODKEY, KEY, view, {.ui = 1 << TAG}},                                                           \
      {MODKEY | ControlMask, KEY, toggleview, {.ui = 1 << TAG}},                                   \
      {MODKEY | ShiftMask, KEY, tag, {.ui = 1 << TAG}}, {                                          \
    MODKEY | ControlMask | ShiftMask, KEY, toggletag, { .ui = 1 << TAG }                           \
  }

#define SHCMD(cmd)                                                                                 \
  {                                                                                                \
    .v = (const char *[]) { "/bin/sh", "-c", cmd, NULL }                                           \
  }

static char dmenumon[2] = "0";
static const char *dmenucmd[] = {
    "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", black,
    "-nf",       gray, "-sb",    cyan,  "-sf",     white, NULL,
};
static const char *termcmd[] = {"alacritty", NULL};
static const char *clipboard_mgr_cmd[] = {"diodon", NULL};
static const char *firefox[] = {"firefox", NULL};
static const char *telegram[] = {"telegram-desktop", NULL};
static const char *inc_volume[] = {"pactl set-sink-volume @DEFAULT_SINK@ +5%", NULL};
static const char *dec_volume[] = {"pactl set-sink-volume @DEFAULT_SINK@ -5%", NULL};
static const char *mute_volume[] = {"pactl set-sink-mute @DEFAULT_SINK@ toggle", NULL};
const char brightness_decrease_cmd[] = "\
current_brightness=$(brightnessctl g | awk -v max=$(brightnessctl max) '{printf \"%.0f\\n\", ($1/max)*100}'); \
if [ $? -ne 0 ] || ! [[ \"$current_brightness\" =~ ^[0-9]+$ ]] || [ \"$current_brightness\" -le 5 ]; then \
    brightnessctl set 5%; \
else \
    brightnessctl set 5%-; \
fi";

static const Key keys[] = {
    // modifier key function argument
    {MODKEY, XK_r, spawn, {.v = dmenucmd}},
    {MODKEY, XK_Return, spawn, {.v = termcmd}},
    {MODKEY, XK_f, spawn, {.v = firefox}},
    {MODKEY, XK_t, spawn, {.v = telegram}},
    {MODKEY, XK_v, spawn, {.v = clipboard_mgr_cmd}},

    {MODKEY | ShiftMask, XK_b, togglebar, {0}},
    {MODKEY, XK_j, focusstack, {.i = +1}},
    {MODKEY, XK_k, focusstack, {.i = -1}},
    {MODKEY, XK_i, incnmaster, {.i = +1}},
    {MODKEY, XK_d, incnmaster, {.i = -1}},
    {MODKEY, XK_h, setmfact, {.f = -0.05}},
    {MODKEY, XK_l, setmfact, {.f = +0.05}},
    // {MODKEY, XK_Return, zoom, {0}},
    {MODKEY, XK_Tab, view, {0}},

    {MODKEY | ShiftMask, XK_c, killclient, {0}},
    {MODKEY | ShiftMask, XK_t, setlayout, {.v = &layouts[0]}},
    {MODKEY | ShiftMask, XK_f, setlayout, {.v = &layouts[1]}},
    {MODKEY | ShiftMask, XK_m, setlayout, {.v = &layouts[2]}},

    {MODKEY, XK_space, setlayout, {0}},
    {MODKEY | ShiftMask, XK_space, togglefloating, {0}},
    {MODKEY, XK_0, view, {.ui = ~0}},
    {MODKEY | ShiftMask, XK_0, tag, {.ui = ~0}},
    {MODKEY, XK_comma, focusmon, {.i = -1}},
    {MODKEY, XK_period, focusmon, {.i = +1}},
    {MODKEY | ShiftMask, XK_comma, tagmon, {.i = -1}},
    {MODKEY | ShiftMask, XK_period, tagmon, {.i = +1}},
    {MODKEY | ShiftMask, XK_q, quit, {0}},

    {0, XF86XK_AudioLowerVolume, spawn, {.v = dec_volume}},
    {0, XF86XK_AudioRaiseVolume, spawn, {.v = dec_volume}},
    {0, XF86XK_AudioMute, spawn, {.v = mute_volume}},
    {0, XF86XK_MonBrightnessDown, spawn, SHCMD(brightness_decrease_cmd)},
    {0, XF86XK_MonBrightnessUp, spawn, SHCMD("brightnessctl set +5%")},
    {0, XK_Print, spawn, SHCMD("flameshot gui -c")},

    TAGKEYS(XK_1, 0),
    TAGKEYS(XK_2, 1),
    TAGKEYS(XK_3, 2),
    TAGKEYS(XK_4, 3),
    TAGKEYS(XK_5, 4),
    TAGKEYS(XK_6, 5),
    TAGKEYS(XK_7, 6),
};

static const Button buttons[] = {
    // click event_mask button function_argument
    // click: ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, ClkRootWin
    {ClkLtSymbol, 0, Button1, setlayout, {0}},
    {ClkLtSymbol, 0, Button3, setlayout, {.v = &layouts[2]}},
    {ClkWinTitle, 0, Button2, zoom, {0}},
    {ClkStatusText, 0, Button2, spawn, {.v = termcmd}},
    {ClkClientWin, MODKEY, Button1, movemouse, {0}},
    {ClkClientWin, MODKEY, Button2, togglefloating, {0}},
    {ClkClientWin, MODKEY, Button3, resizemouse, {0}},
    {ClkTagBar, 0, Button1, view, {0}},
    {ClkTagBar, 0, Button3, toggleview, {0}},
    {ClkTagBar, MODKEY, Button1, tag, {0}},
    {ClkTagBar, MODKEY, Button3, toggletag, {0}},
};

