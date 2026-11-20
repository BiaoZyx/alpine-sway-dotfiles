# 不使用无障碍（AT-SPI）总线：Wayland/sway 桌面不需要它，
# 关掉可以避免每次登录都拉起 at-spi-bus-launcher / registryd 等一整套进程。
export NO_AT_BRIDGE=1
