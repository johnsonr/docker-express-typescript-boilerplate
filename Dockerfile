FROM node:14.17.1@sha256:a3d7d005ba5bfa5f48b10d4fe0ed937644f5b0bc0b583e7c7f1811384cf30911 as base

# Add package file
COPY package*.json ./

# Install deps
RUN npm i

# Copy source
COPY src ./src
COPY tsconfig.json ./tsconfig.json
COPY openapi.json ./openapi.json

# Build dist
RUN npm run build

# Start production image build
FROM gcr.io/distroless/nodejs:14@sha256:80eff5f630a0c0f86dc6a228e970d23dbc614f2879fd4b9232e8faed353d38ca

# Copy node modules and build directory
COPY --from=base ./node_modules ./node_modules
COPY --from=base /dist /dist

# Copy static files
COPY src/public dist/src/public

# Expose port 3000
EXPOSE 3000
CMD ["dist/src/server.js"]
