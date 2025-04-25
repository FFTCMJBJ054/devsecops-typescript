# -------- Stage 1: Build Stage --------
    FROM node:20-alpine AS builder

    # Set working directory
    WORKDIR /app
    
    # Install dependencies
    COPY package.json package-lock.json ./
    RUN npm ci
    
    # Copy the rest of the app
    COPY . .
    
    # Build the app (assumes output goes to /app/dist or /app/build)
    RUN npm run build
    
    # -------- Stage 2: NGINX Stage --------
    FROM nginx:alpine AS nginx
    
    # Remove default nginx static assets
    RUN rm -rf /usr/share/nginx/html/*
    
    # Copy compiled app from builder stage
    COPY --from=builder /app/dist /usr/share/nginx/html
    
    # Copy custom nginx config (optional)
    # COPY nginx.conf /etc/nginx/nginx.conf
    
    # Expose port 80
    EXPOSE 80
    
    # Start NGINX
    CMD ["nginx", "-g", "daemon off;"]
    