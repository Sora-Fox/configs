import os

config.load_autoconfig(False)
c.url.start_pages = "https://www.google.com"
c.url.searchengines = {
    "DEFAULT": "https://www.google.com/search?q={}",
    "g":       "https://duckduckgo.com/?q={}",
    "y":       "https://www.youtube.com/results?search_query={}",
}

# ============= APPEARANCE ===========
c.colors.webpage.darkmode.enabled = True
c.zoom.default = "125%"
c.fonts.default_size = "13pt"
c.fonts.default_family = "Source Code Pro"
c.tabs.position = "top"
c.tabs.width = 200
c.statusbar.show = "always"

# ============= PRIVACY ===========
c.content.tls.certificate_errors = "block"
c.content.private_browsing = True
c.auto_save.session = False
c.content.cache.size = 0
c.auto_save.interval = 0
c.content.cookies.store = False
c.content.cookies.accept = "no-3rdparty"
c.content.webrtc_ip_handling_policy = "disable-non-proxied-udp"
c.content.autoplay = False
os.system("rm -rf ~/.cache/qutebrowser/*")

# ========== ADD BLOCKING ===============
c.content.blocking.method = "adblock"
c.content.blocking.hosts.lists = [
    "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts",
    "https://easylist.to/easylist/easylist.txt",
    "https://easylist.to/easylist/easyprivacy.txt",
    "https://raw.githubusercontent.com/Ultimate-Hosts-Blacklist/Ultimate.Hosts.Blacklist/refs/heads/master/hosts/hosts0",
    "https://raw.githubusercontent.com/Ultimate-Hosts-Blacklist/Ultimate.Hosts.Blacklist/refs/heads/master/hosts/hosts1",
    "https://raw.githubusercontent.com/Ultimate-Hosts-Blacklist/Ultimate.Hosts.Blacklist/refs/heads/master/hosts/hosts2",
    "https://raw.githubusercontent.com/Ultimate-Hosts-Blacklist/Ultimate.Hosts.Blacklist/refs/heads/master/hosts/hosts3"
]

# ======= BINDINGS ===========
config.bind("<Ctrl-r>", "config-source")
config.bind("x", "tab-close")
config.bind("t", "open -t")

