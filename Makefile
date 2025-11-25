APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=regreth
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
# default
TARGETOS=linux
TARGETARCH=arm64

# Supported platforms
LINUX_OS=linux
LINUX_ARCH=amd64
ARM_OS=linux
ARM_ARCH=arm64
MACOS_OS=darwin
MACOS_ARCH=amd64
WINDOWS_OS=windows
WINDOWS_ARCH=amd64

format: 
	gofmt -s -w ./

.PHONY: format lint test get build linux arm macos windows all image push clean

lint:
	golint

test:
	go test -v

get:
	go mod download

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X=github.com/git-account/kbot/cmd.appVersion=${VERSION}"

# Build for specific platforms
linux: format get
	CGO_ENABLED=0 GOOS=${LINUX_OS} GOARCH=${LINUX_ARCH} go build -v -o kbot-${LINUX_OS}-${LINUX_ARCH} -ldflags "-X=github.com/git-account/kbot/cmd.appVersion=${VERSION}"

arm: format get
	CGO_ENABLED=0 GOOS=${ARM_OS} GOARCH=${ARM_ARCH} go build -v -o kbot-${ARM_OS}-${ARM_ARCH} -ldflags "-X=github.com/git-account/kbot/cmd.appVersion=${VERSION}"

macos: format get
	CGO_ENABLED=0 GOOS=${MACOS_OS} GOARCH=${MACOS_ARCH} go build -v -o kbot-${MACOS_OS}-${MACOS_ARCH} -ldflags "-X=github.com/git-account/kbot/cmd.appVersion=${VERSION}"

windows: format get
	CGO_ENABLED=0 GOOS=${WINDOWS_OS} GOARCH=${WINDOWS_ARCH} go build -v -o kbot-${WINDOWS_OS}-${WINDOWS_ARCH}.exe -ldflags "-X=github.com/git-account/kbot/cmd.appVersion=${VERSION}"

all: linux arm macos windows
	@echo "Built all platforms"

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}
clean:
	rm -rf kbot kbot-* *.exe