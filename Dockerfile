# -------------------------
# Stage 1: Build
# -------------------------
FROM golang:1.22 AS builder

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go.mod and go.sum first (for dependency caching)
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the source code
COPY . .

# Build the Go app
RUN CGO_ENABLED=0 GOOS=linux go build -o main .

# -------------------------
# Stage 2: Run
# -------------------------
FROM alpine:3.20

# Set working directory
WORKDIR /root/

# Copy binary from builder
COPY --from=builder /app/main .

# Expose application port (change if needed)
EXPOSE 8080

# Command to run the executable
CMD ["./main"]
