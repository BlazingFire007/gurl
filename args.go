package main

import (
	"flag"
	"fmt"
	"os"

	"rsc.io/getopt"
)

type Options struct {
	url             string
	output          string
	user_agent      string
	data            string
	file            string
	cookie          string
	headers         string
	post            bool
	include_headers bool
	times           int
	silent          bool
	infinite        bool
}

func parse_args() Options {
	args := Options{}
	var help bool
	var version bool
	const VER string = "0.1.0"
	flag.StringVar(&args.output, "o", "", "Write to file instead of stdout")
	flag.IntVar(&args.times, "n", 1, "Number of times to send the request. Max 10,000. (WARNING: ASYNC)")
	flag.BoolVar(&args.silent, "s", false, "Silent")
	flag.StringVar(&args.headers, "H", "", "Set headers: \"HEADER1::VAL1|||HEADER2::VAL2\"")
	flag.StringVar(&args.data, "d", "", "HTTP POST data")
	flag.BoolVar(&args.post, "p", false, "Send POST request")
	flag.StringVar(&args.file, "u", "", "Transfer local FILE to destination")
	flag.StringVar(&args.user_agent, "A", "gurl/"+VER, "Send User-Agent <name> to server")
	flag.StringVar(&args.cookie, "c", "", "set cookie from FILE")
	flag.BoolVar(&args.include_headers, "i", false, "Include protocol response headers in the output")
	flag.BoolVar(&version, "v", false, "Display the version of this program")
	flag.BoolVar(&help, "h", false, "Show this screen")
	flag.BoolVar(&args.infinite, "loop", false, "Send request until program error. (DO NOT USE: IGNORES ERRORS)")
	getopt.Aliases(
		"o", "output",
		"n", "times",
		"s", "silent",
		"H", "headers",
		"d", "data",
		"p", "post",
		"u", "upload",
		"A", "user-agent",
		"c", "cookie",
		"i", "include",
		"v", "version",
		"h", "help",
		"l", "loop",
	)
	flag.Usage = func() {
		getopt.PrintDefaults()
		os.Exit(1)
	}
	getopt.Parse()

	if help {
		fmt.Println("Usage: gurl [options..] <url>")
		getopt.PrintDefaults()
		os.Exit(0)
	}
	if version {
		fmt.Printf("GURL VERSION: %s\n", VER)
		os.Exit(0)
	}

	if len(flag.Args()) != 1 {
		fmt.Println("Usage: gurl [options..] <url>")
		getopt.PrintDefaults()
		os.Exit(1)
	}

	args.url = flag.Args()[0]
	return args
}
