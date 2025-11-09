# Dockerfile
# 공식 Nginx 이미지를 베이스로 사용합니다.
FROM nginx:latest

# 컨테이너 내의 Nginx 기본 설정 파일을 제거하거나 백업합니다.
# RUN rm /etc/nginx/conf.d/default.conf

# 로컬의 설정 파일(nginx.conf)을 컨테이너의 Nginx 설정 경로에 복사
# 이 파일은 conf.d/ 디렉토리에 있는 개별 도메인 설정을 include 합니다.
COPY nginx.conf /etc/nginx/nginx.conf

# 로컬의 도메인별 설정 파일을 컨테이너의 Nginx 설정 디렉토리에 복사
COPY conf.d/ /etc/nginx/conf.d/

# 로컬의 웹 페이지 파일을 컨테이너의 Nginx 정적 파일 제공 경로에 복사
# 여기서는 Nginx 기본 경로를 그대로 사용합니다.
COPY html/ /usr/share/nginx/html/

# Nginx는 기본적으로 80 포트를 사용합니다. (정보 제공용, 실제 포트 오픈은 run 시점에)
EXPOSE 8080
 