# 配置 Android Studio（/opt 目录）内嵌 JDK 的 JAVA_HOME
set -x JAVA_HOME /opt/android-studio/jbr

# 将 JDK bin 目录添加到 PATH，使 java 命令全局可用
set -x PATH $JAVA_HOME/bin $PATH
