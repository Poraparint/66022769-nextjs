# สเตจแรก: สร้าง Next.js build
FROM node:18 AS builder

WORKDIR /app

# คัดลอก package.json และ lockfile เพื่อ cache dependencies
COPY package.json package-lock.json ./

# ติดตั้ง dependencies
RUN npm install

# คัดลอกโค้ดทั้งหมด
COPY . .

# Build Next.js เป็น production
RUN npm run build

# สเตจสอง: ใช้ NGINX เพื่อเสิร์ฟไฟล์ Static
FROM nginx:latest

# คัดลอกไฟล์ Static ที่ Build มาใส่ใน NGINX
COPY --from=builder /app/out /usr/share/nginx/html

# คัดลอกไฟล์ Config ของ NGINX
COPY nginx.conf /etc/nginx/nginx.conf

# เปิดพอร์ต 80
EXPOSE 80

# รัน NGINX
CMD ["nginx", "-g", "daemon off;"]
