FROM golang:1.24-alpine AS build

WORKDIR /app
COPY . .

ENV GIN_MODE=release

RUN go mod download
RUN go build -o /app/rtsp_to_webrtc

FROM alpine:latest

WORKDIR /app
COPY --from=build /app/rtsp_to_webrtc .
COPY --from=build /app/config.json .
COPY --from=build /app/web /app/web

CMD ["./rtsp_to_webrtc"]