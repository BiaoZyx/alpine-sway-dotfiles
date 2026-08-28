config.load_autoconfig()

# 广告拦截器
c.content.blocking.enabled = True

# 优先向网站请求简体中文内容
c.content.headers.accept_language = "zh-CN,zh;q=0.9,en;q=0.8"

# 优先请求深色网页
c.colors.webpage.preferred_color_scheme = 'dark'
c.colors.webpage.darkmode.enabled = True    # 强制深色
c.colors.webpage.darkmode.policy.images = 'never'

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
    "DEFAULT": "https://cn.bing.com/search?q={}"
}

# 编辑器设置 - 使用 foot 启动 vim (记得修改)
c.editor.command = [
    "/usr/bin/foot",
    "-e",
    "/usr/bin/vim",
    "+{line}",
    "{file}"
]

# 主页（空可以写file:///dev/null）
c.url.start_pages = 'https://inftab.com'
c.url.default_page= 'https://inftab.com'

# 快捷键
config.bind('cs', 'config-source')         # 刷新配置

config.bind('zi', 'zoom-in')               # 放大
config.bind('zo', 'zoom-out')              # 缩小

config.bind('si', 'hint images download')  # 选择并下载图片

config.bind('gp', 'open -p')               # 隐私模式

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

# 5. 网页内容（不变）
c.fonts.web.family.standard = "Noto Sans CJK SC"
c.fonts.web.family.sans_serif = "Noto Sans CJK SC"
c.fonts.web.family.serif = "Noto Serif CJK SC"
c.fonts.web.family.fixed = "JetBrainsMono Nerd Font Mono"

c.fonts.web.size.default = 11
c.fonts.web.size.default_fixed = 10

# 6. CSS 强制覆盖（保留）
c.content.user_stylesheets = ['~/.config/qutebrowser/style.css']
