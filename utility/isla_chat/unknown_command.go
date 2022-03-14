package main

import (
	"bytes"
	"net/http"
	"os"
	"strings"
)

func main() {
	var message string
	var response string

	if os.Args[1] == "say" {
		for _, arg := range os.Args[2:] {
			message += arg + " "
		}
		response = ask_isla(message)
		// Format the response so that the original message is displayed.
		response = ">>> " + message + "\n " + strings.Join(strings.Split(response, "\n"), "\n ")
	} else {
		// This is so that the chat server can respond with queued messages.
		response = ask_isla("_")
		// Exit if the buffer is empty.
		if strings.HasPrefix(response, "Command not found") {
			os.Exit(0)
		}
		// Since we aren't the ones sending the message, we don't need to display the message.
		response = " " + strings.Join(strings.Split(response, "\n"), "\n ")
	}

	// Write the response to /tmp/isla_chat.txt.
	file, err := os.Create("/tmp/isla_chat.txt")
	if err != nil {
		panic(err)
	}
	defer file.Close()
	file.WriteString(response)
}

func ask_isla(message string) string {
	// Post the message to the chat server.
	resp, err := http.Post("http://192.168.1.234:9123/", "application/json", bytes.NewBuffer([]byte(`{"message": "`+message+`"}`)))
	if err != nil {
		panic(err)
	}
	defer resp.Body.Close()

	// Print the response.
	body := make([]byte, 1024)
	resp.Body.Read(body)
	// Remove the trailing newline.
	return string(body[:len(body)-1])
}
