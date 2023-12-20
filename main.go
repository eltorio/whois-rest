package main

import (
	"fmt"
	"net"
	"net/http"
	"os"
	"strconv"
	"time"
)

func isPositiveInteger(s string) bool {
	n, err := strconv.Atoi(s)
	if err != nil {
		return false
	}
	return n > 0
}

func isValidFQDN(fqdn string) bool {
	// Vérifie si le FQDN peut être résolu en une adresse IP (IPv4 ou IPv6)
	ips, err := net.LookupIP(fqdn)
	if err != nil || len(ips) == 0 {
		return false
	}

	// Vérifie si le serveur distant répond sur le port TCP 43
	for _, ip := range ips {
		conn, err := net.DialTimeout("tcp", net.JoinHostPort(ip.String(), "43"), time.Second*5)
		if err == nil {
			conn.Close()
			return true
		}
	}

	return false
}

func whoisHandler(w http.ResponseWriter, r *http.Request) {
	host := r.URL.Query().Get("host")
	if host == "" {
		http.Error(w, "Missing 'host' parameter", http.StatusBadRequest)
		return
	}

	whoisServer := os.Getenv("WHOIS_SERVER")
	if whoisServer == "" || !isValidFQDN(whoisServer) {
		whoisServer = "whois.cymru.com"
	}

	conn, err := net.Dial("tcp", whoisServer+":43")
	if err != nil {
		http.Error(w, fmt.Sprintf("Error connecting to WHOIS server: %s", err), http.StatusInternalServerError)
		return
	}
	defer conn.Close()

	_, err = conn.Write([]byte(host + "\r\n"))
	if err != nil {
		http.Error(w, fmt.Sprintf("Error sending WHOIS request: %s", err), http.StatusInternalServerError)
		return
	}

	buffer := make([]byte, 4096)
	n, err := conn.Read(buffer)
	if err != nil {
		http.Error(w, fmt.Sprintf("Error reading WHOIS response: %s", err), http.StatusInternalServerError)
		return
	}

	fmt.Fprintf(w, "%s", buffer[:n])
}

func main() {
	httpPort := os.Getenv("HTTP_PORT")
	if httpPort == "" || !isPositiveInteger(httpPort) {
		httpPort = "8080"
	}

	http.HandleFunc("/whois", whoisHandler)

	err := http.ListenAndServe(":"+httpPort, nil)
	if err != nil {
		fmt.Printf("Server could not start: %s\n", err)
		os.Exit(1)
	}
}
