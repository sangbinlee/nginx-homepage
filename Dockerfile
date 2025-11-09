# Dockerfile
# 공식 Nginx 이미지를 베이스로 사용합니다.
FROM nginx:latest

# 1단계에서 준비한 설정 파일과 HTML 파일을 이미지 내부의 Nginx 경로에 복사합니다.
# Dockerfile과 같은 경로에 있는 index.html 파일을 이미지의 /usr/share/nginx/html/ 경로로 복사
COPY index.html /usr/share/nginx/html/
# Dockerfile과 같은 경로에 있는 nginx.conf 파일을 이미지의 /etc/nginx/ 경로로 복사
COPY nginx.conf /etc/nginx/

# Nginx는 기본적으로 80 포트를 사용합니다. (정보 제공용, 실제 포트 오픈은 run 시점에)
EXPOSE 8080

# 컨테이너가 시작될 때 Nginx를 실행합니다. (기본 이미지에 설정되어 있어 생략 가능하나 명시적으로 추가)
CMD ["nginx", "-g", "daemon off;"]