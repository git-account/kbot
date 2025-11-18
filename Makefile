VERSION

format: 
	gofmt -s -w ./

build:
    go build -v -o kbot -ldflags "-X="github.com/git-account/kbot/cmd.appVersion=${VERSION}
    
