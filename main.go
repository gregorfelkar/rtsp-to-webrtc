package main

import (
	"log"
	"os"
	"os/signal"
	"syscall"
)

func main() {
	log.Println("RTSP to WebRTC Server")
	
	go serveHTTP()
	go serveStreams()

	sigs := make(chan os.Signal, 1)
	done := make(chan bool, 1)
	signal.Notify(sigs, syscall.SIGINT, syscall.SIGTERM)

	go func() {
		sig := <-sigs
		log.Println(sig)
		done <- true
	}()

	log.Println("Server Start Awaiting Signal")
	<-done
	log.Println("Exiting")
}
