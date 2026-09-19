config.load_autoconfig()

import os
import json

# 把 qutebrowser quickmarks 导出到主页可用的 quickmarks.js
def _export_quickmarks():
    base = os.path.dirname(os.path.abspath(__file__))
    src = os.path.join(base, 'quickmarks')
    dst = os.path.join(base, 'quickmarks.js')
    items = []
    try:
        with open(src, encoding='utf-8') as f:
            for line in f:
                line = line.strip()
                if not line or line.startswith('#'):
                    continue
                parts = line.rsplit(maxsplit=1)
                if len(parts) != 2:
                    continue
                items.append({"name": parts[0], "url": parts[1]})
    except OSError:
        pass
    with open(dst, 'w', encoding='utf-8') as f:
        f.write("var QUICKMARKS=" + json.dumps(items, ensure_ascii=False) + ";")

_export_quickmarks()

# 把 links.txt 导出到主页可用的 links.js
def _export_links():
    base = os.path.dirname(os.path.abspath(__file__))
    src = os.path.join(base, 'links.txt')
    dst = os.path.join(base, 'links.js')
    items = []
    try:
        with open(src, encoding='utf-8') as f:
            for line in f:
                line = line.strip()
                if not line or line.startswith('#'):
                    continue
                parts = [p.strip() for p in line.split('|')]
                if not parts or not parts[0]:
                    continue
                item = {"name": parts[0]}
                item["url"] = parts[1] if len(parts) > 1 and parts[1] else parts[0]
                item["icon"] = parts[2] if len(parts) > 2 and parts[2] else ''
                items.append(item)
    except OSError:
        pass
    with open(dst, 'w', encoding='utf-8') as f:
        f.write("var LINKS=" + json.dumps(items, ensure_ascii=False) + ";")

_export_links()

# ========== Material You 配色：跟随系统深浅自动切换 ==========
import subprocess

# 与 home.html 一致的深/浅两套色板
_M3 = {
    'dark': {
        'surface': '#141218', 'surface_low': '#1D1B20',
        'surface_container': '#211F26', 'surface_high': '#2B2930', 'surface_highest': '#36343B',
        'on_surface': '#E6E0E9', 'on_variant': '#CAC4D0',
        'outline': '#938F99', 'outline_variant': '#49454F',
        'primary': '#D0BCFF', 'on_primary': '#381E72',
        'primary_container': '#4F378B', 'on_primary_container': '#EADDFF',
        'secondary_container': '#4A4458', 'on_secondary_container': '#E8DEF8',
        'tertiary': '#EFB8C8', 'error': '#FFB4AB', 'on_error': '#690005',
        'ind_start': '#8AB4F8', 'ind_stop': '#7C3AED',
    },
    'light': {
        'surface': '#FEF7FF', 'surface_low': '#F7F2FA',
        'surface_container': '#F3EDF7', 'surface_high': '#ECE6F0', 'surface_highest': '#E6E0E9',
        'on_surface': '#1D1B20', 'on_variant': '#49454F',
        'outline': '#79747E', 'outline_variant': '#CAC4D0',
        'primary': '#6750A4', 'on_primary': '#FFFFFF',
        'primary_container': '#EADDFF', 'on_primary_container': '#21005D',
        'secondary_container': '#E8DEF8', 'on_secondary_container': '#1D192B',
        'tertiary': '#7D5260', 'error': '#BA1A1A', 'on_error': '#FFFFFF',
        'ind_start': '#1A73E8', 'ind_stop': '#4F378B',
    },
}

# qutebrowser 颜色项 -> 色板键（不存在的项会安全跳过）
_M3_MAP = {
    'tabs.bar.bg': 'surface_container',
    'tabs.indicator.start': 'ind_start', 'tabs.indicator.stop': 'ind_stop', 'tabs.indicator.error': 'error',
    'tabs.selected.even.bg': 'surface_high', 'tabs.selected.even.fg': 'on_surface',
    'tabs.selected.odd.bg': 'surface_high', 'tabs.selected.odd.fg': 'on_surface',
    'tabs.even.bg': 'surface_container', 'tabs.even.fg': 'on_variant',
    'tabs.odd.bg': 'surface_container', 'tabs.odd.fg': 'on_variant',
    'tabs.pinned.selected.even.bg': 'surface_high', 'tabs.pinned.selected.even.fg': 'on_surface',
    'tabs.pinned.selected.odd.bg': 'surface_high', 'tabs.pinned.selected.odd.fg': 'on_surface',
    'tabs.pinned.even.bg': 'surface_container', 'tabs.pinned.even.fg': 'on_variant',
    'tabs.pinned.odd.bg': 'surface_container', 'tabs.pinned.odd.fg': 'on_variant',
    'statusbar.normal.bg': 'surface', 'statusbar.normal.fg': 'on_surface',
    'statusbar.insert.bg': 'surface_container', 'statusbar.insert.fg': 'primary',
    'statusbar.command.bg': 'surface_high', 'statusbar.command.fg': 'on_surface',
    'statusbar.url.fg': 'on_variant',
    'statusbar.url.success.https.fg': 'primary',
    'statusbar.url.success.http.fg': 'tertiary',
    'statusbar.url.error.fg': 'error', 'statusbar.url.warn.fg': 'tertiary',
    'statusbar.url.hover.fg': 'on_surface',
    'statusbar.progress.bg': 'primary',
    'completion.category.bg': 'surface_highest', 'completion.category.fg': 'primary',
    'completion.category.border.top': 'surface_highest', 'completion.category.border.bottom': 'surface_highest',
    'completion.even.bg': 'surface_container', 'completion.odd.bg': 'surface_low',
    'completion.item.selected.bg': 'primary_container', 'completion.item.selected.fg': 'on_primary_container',
    'completion.item.selected.border.top': 'primary_container', 'completion.item.selected.border.bottom': 'primary_container',
    'completion.match.fg': 'primary', 'completion.item.selected.match.fg': 'primary',
    'completion.scrollbar.bg': 'surface_high', 'completion.scrollbar.fg': 'outline',
    'downloads.bar.bg': 'surface_container',
    'downloads.start.bg': 'surface_highest', 'downloads.start.fg': 'on_surface',
    'downloads.stop.bg': 'surface_highest', 'downloads.stop.fg': 'on_variant',
    'downloads.error.bg': 'error', 'downloads.error.fg': 'on_error',
    'hints.bg': 'primary', 'hints.fg': 'on_primary', 'hints.match.fg': 'tertiary',
    'keyhint.bg': 'surface_high', 'keyhint.fg': 'on_variant',
    'messages.info.bg': 'surface_highest', 'messages.info.fg': 'on_surface',
    'messages.warning.bg': 'tertiary', 'messages.warning.fg': 'on_surface',
    'messages.error.bg': 'error', 'messages.error.fg': 'on_error',
    'prompts.bg': 'surface_high', 'prompts.fg': 'on_surface',
    'prompts.selected.bg': 'primary_container', 'prompts.selected.fg': 'on_primary_container',
}

def _detect_scheme():
    """判断系统深浅：env 覆盖 > Qt colorScheme > gsettings > 默认深色。"""
    env = os.environ.get('QUTE_SCHEME', '').strip().lower()
    if env in ('dark', 'light'):
        return env
    try:
        from qutebrowser.qt.gui import QGuiApplication
        name = str(QGuiApplication.styleHints().colorScheme()).lower()
        if 'dark' in name:
            return 'dark'
        if 'light' in name:
            return 'light'
    except Exception:
        pass
    try:
        out = subprocess.run(
            ['gsettings', 'get', 'org.gnome.desktop.interface', 'color-scheme'],
            capture_output=True, text=True, timeout=2).stdout.lower()
        if 'dark' in out:
            return 'dark'
        if 'light' in out:
            return 'light'
    except Exception:
        pass
    return 'dark'

def _apply_m3(scheme):
    p = _M3.get(scheme, _M3['dark'])
    for opt, key in _M3_MAP.items():
        if key is None:
            continue
        try:
            config.set('colors.' + opt, p[key])
        except Exception:
            pass
    try:
        # 让网页 prefers-color-scheme 与浏览器 chrome 保持一致
        config.set('colors.webpage.preferred_color_scheme', scheme)
        # 深色时强制网页暗色滤镜，浅色时关闭
        config.set('colors.webpage.darkmode.enabled', scheme == 'dark')
        # 提示框边框（需要 "粗细 样式 颜色" 形式）
        config.set('colors.prompts.border', '1px solid ' + p['outline_variant'])
        # f 模式 hint 标签边框（默认黄色 #E3BE23）
        config.set('hints.border', '1px solid ' + p['on_primary'])
    except Exception:
        pass

_apply_m3(_detect_scheme())

# 系统深浅变化时实时重刷（Qt 6.5+；来源可用时才会触发）
def _on_scheme_changed(*_):
    _apply_m3(_detect_scheme())

try:
    from qutebrowser.qt.gui import QGuiApplication
    QGuiApplication.styleHints().colorSchemeChanged.connect(_on_scheme_changed)
except Exception:
    pass

# 广告拦截器
c.content.blocking.enabled = True

# 优先向网站请求简体中文内容
c.content.headers.accept_language = "zh-CN,zh;q=0.9,en;q=0.8"

# 优先请求深色网页（深浅跟随系统，由上方 _apply_m3 设置）
c.colors.webpage.darkmode.policy.images = 'never'
c.colors.webpage.darkmode.policy.page = 'smart'

# 网页平滑滚动
c.scrolling.smooth = True

# 下载
c.downloads.location.directory = "~/Downloads"    # 下载目录（记得改）
c.downloads.position = "bottom"    # 下载栏位置（底部）

# 新建标签页在当前标签页右边
c.tabs.new_position.related = 'next'

'''
# 搜索引擎设置
c.url.searchengines = {
    "DEFAULT": "https://cn.bing.com/search?q={}",
    "g": "https://www.google.com/search?q={}",
    "b": "https://cn.bing.com/search?q={}",
    "y": "https://www.youtube.com/results?search_query={}",
    "w": "https://en.wikipedia.org/wiki/Special:Search?search={}",
    "github": "https://github.com/search?q={}",
}
'''
c.url.searchengines = {
    "DEFAULT": "https://www.bing.com/search?q={}"
}

# 编辑器设置 - 使用 foot 启动 vim (记得修改)
c.editor.command = [
    "/usr/bin/foot",
    "-e",
    "/usr/bin/vim",
    "+{line}",
    "{file}"
]

# 主页（本地 Material You 主页）
c.url.start_pages = 'file:///home/xue/.config/qutebrowser/home.html'
c.url.default_page = 'file:///home/xue/.config/qutebrowser/home.html'

# 主页本地文件自带深色主题，跳过强制暗色滤镜
config.set('colors.webpage.darkmode.enabled', False, 'file://*')

# 快捷键
config.bind('cs', 'config-source')         # 刷新配置

config.bind('zi', 'zoom-in')               # 放大
config.bind('zo', 'zoom-out')              # 缩小

config.bind('si', 'hint images download')  # 选择并下载图片

config.bind('gp', 'open -p')               # 隐私模式

config.bind(',s', 'spawn --userscript save_links')  # 在主页把浏览器改动的常用链接写入 links.txt

# ========== 界面字体配置 ==========
# 1. 地址栏（输入命令/网址的地方）
c.fonts.prompts = '11pt "JetBrainsMono Nerd Font Mono"'

# 2. 状态栏（底部显示信息的地方）
c.fonts.statusbar = '11pt "JetBrainsMono Nerd Font Mono"'

# 3. 标签页标题
c.fonts.tabs.selected = 'bold 11pt "Noto Sans CJK SC"'
c.fonts.tabs.unselected = '10pt "Noto Sans CJK SC"'

# 4. 消息提示
c.fonts.messages.info = '10pt "JetBrainsMono Nerd Font Mono"'
c.fonts.messages.warning = '10pt "JetBrainsMono Nerd Font Mono"'
c.fonts.messages.error = '10pt "JetBrainsMono Nerd Font Mono"'
c.colors.messages.info.fg = '#ffffff'   # `,s` 保存提示白字
c.colors.messages.info.bg = '#000000'   # 黑底，避免看起来像红色报错

# 5. 网页内容（不变）
c.fonts.web.family.standard = "Noto Sans CJK SC"
c.fonts.web.family.sans_serif = "Noto Sans CJK SC"
c.fonts.web.family.serif = "Noto Serif CJK SC"
c.fonts.web.family.fixed = "JetBrainsMono Nerd Font Mono"

c.fonts.web.size.default = 11
c.fonts.web.size.default_fixed = 10

config.set("content.headers.user_agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36", "coding.qq.com")
