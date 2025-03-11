FROM golang:1.24-alpine AS build

WORKDIR /app
COPY . .

RUN go mod download

ENV GIN_MODE=release
ENV GOOS=linux 
ENV GOARCH=amd64 
RUN go build -ldflags "-s -w" -o /app/rtsp_to_webrtc

FROM alpine:latest

WORKDIR /app
COPY --from=build /app/rtsp_to_webrtc .
COPY --from=build /app/config.json .
COPY --from=build /app/web /app/web

CMD ["./rtsp_to_webrtc"]