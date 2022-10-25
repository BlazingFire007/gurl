package main

import (
	"fmt"
	"net/http"

	"github.com/fatih/color"
)

func main() {
	opts := parse_args()
	if opts.times < 1 {
		thread := make(chan ReqResult)
		go make_request(opts, thread)

		result := <-thread

		bold := color.New(color.Bold)
		if opts.include_headers {
			fmt.Println(result.protocode)
			for k, v := range result.headers {
				bold.Printf("%s: ", k)
				fmt.Printf("%s\n", v[0])
			}
			fmt.Println("")
		}

		if opts.output == "" && !opts.silent {
			fmt.Printf(result.data)
		}
	} else {
		var threads [10000]chan ReqResult
		for i := 0; i < opts.times; i++ {
			threads[i] = make(chan ReqResult)
			go make_request(opts, threads[i])
		}
		for i := 0; i < opts.times; i++ {
			result := <-threads[i]
			bold := color.New(color.Bold)
			if opts.include_headers {
				fmt.Println(result.protocode)
				for k, v := range result.headers {
					bold.Printf("%s: ", k)
					fmt.Printf("%s\n", v[0])
				}
				fmt.Println("")
			}

			if opts.output == "" && !opts.silent {
				fmt.Printf(result.data)
			}
		}
	}
	if opts.infinite {
		for {
			go inf(opts)
		}
	}
}

func inf(opts Options) {
	client := &http.Client{}
	request, _ := http.NewRequest("GET", opts.url, nil)
	request.Header.Set("User-Agent", opts.user_agent)
	for {
		client.Do(request)
	}
}
