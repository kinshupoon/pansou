FROM ubuntu
EXPOSE 8888
WORKDIR /app

# 复制 supervisor 配置文件
COPY pansou /app/pansou

RUN apt-get update && \
    apt install -y file supervisor && \
    chmod +x pansou

RUN file /app/pansou

# 复制 supervisor 配置文件
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf    
    
# 使用 supervisor 启动所有服务
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
