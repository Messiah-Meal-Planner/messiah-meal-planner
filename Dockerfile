# -------------------------
# 1. Build stage
# -------------------------
FROM node:18-alpine AS builder

WORKDIR /app

# Install dependencies first (optimized caching)
COPY package.json package-lock.json ./
RUN npm ci

# Copy source and build
COPY . .
RUN npm run build  
# produces the "dist" folder

# -------------------------
# 2. Runtime stage
# -------------------------
FROM nginx:stable-alpine

# Copy build output to nginx
COPY --from=builder /app/dist /usr/share/nginx/html

# Optional: custom nginx config for SPA routing
# COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
