# Étape de construction
FROM golang:alpine AS builder

WORKDIR /app
COPY go.mod ./
RUN go mod download
COPY main.go .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o whois .


FROM alpine:latest  
WORKDIR /root/
COPY --from=builder /app/whois /usr/local/bin/
ENV HTTP_PORT=8080
ENV WHOIS_SERVER=whois.cymru.com
EXPOSE 8080
CMD ["/usr/local/bin/whois"] 
