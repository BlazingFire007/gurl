package main

import (
	"bytes"
	"io"
	"log"
	"mime/multipart"
	"net/http"
	"os"
	"strings"
)

type ReqResult struct {
	data      string
	headers   http.Header
	protocode string
}

func make_request(opts Options, result chan ReqResult) {
	if !strings.HasPrefix(opts.url, "http") && !strings.HasPrefix(opts.url, "https") {
		opts.url = "http://" + opts.url
	}
	client := &http.Client{CheckRedirect: func(r *http.Request, via []*http.Request) error {
		r.URL.Opaque = r.URL.Path
		return nil
	}}
	result <- req(client, opts)
}

func req(client *http.Client, opts Options) ReqResult {
	var req *http.Request
	var err error = nil
	if opts.post || opts.file != "" {
		req = handle_post(opts)
	} else {
		req, err = http.NewRequest("GET", opts.url, nil)
	}
	check(err)
	req.Header.Set("User-Agent", opts.user_agent)
	if opts.cookie != "" {
		b, err := os.ReadFile(opts.cookie)
		check(err)
		req.Header.Set("Cookie", string(b))
	}

	if opts.headers != "" {
		d := strings.Split(opts.headers, "|||")
		for i := 0; i < len(d); i++ {
			v := strings.Split(d[i], "::")
			req.Header.Set(v[0], v[1])
		}
	}

	response, err := client.Do(req)
	check(err)
	data, err := io.ReadAll(response.Body)
	check(err)
	if opts.output != "" {

		result := to_file(opts.output, response.Body)
		result.headers = response.Header
		result.protocode = response.Proto + " " + response.Status
		return result
	}
	protocode := response.Proto + " " + response.Status
	return ReqResult{data: string(data), headers: response.Header, protocode: protocode}
}

func handle_post(opts Options) *http.Request {
	if opts.data != "" {
		b := []byte(opts.data)
		req, err := http.NewRequest("POST", opts.url, bytes.NewBuffer(b))
		check(err)
		return req
	} else {
		buf := new(bytes.Buffer)
		writer := multipart.NewWriter(buf)
		part, err := writer.CreateFormFile("file", opts.file)
		check(err)
		data, err := os.ReadFile(opts.file)
		check(err)
		part.Write(data)
		writer.Close()
		req, err := http.NewRequest("POST", opts.url, buf)
		check(err)
		req.Header.Set("Content-Type", writer.FormDataContentType())
		return req
	}
}

func to_file(path string, body io.ReadCloser) ReqResult {
	file, err := os.Create(path)
	check(err)
	size, err := io.Copy(file, body)
	check(err)
	if size > 0 {
		defer file.Close()
	}
	return ReqResult{}
}

func check(err error) {
	if err != nil {
		log.Fatal(err)
	}
}
