# syntax=docker/dockerfile:1.4

ARG TARGETOS=linux
ARG TARGETARCH=amd64
ARG VERSION=dev
ARG BASE_IMAGE=scratch

FROM golang:1.24 AS builder
WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY . .

# Build the target binary for the specified GOOS/GOARCH
ARG TARGETOS
ARG TARGETARCH
ARG VERSION
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} \
	go build -v -o /kbot -ldflags "-X=github.com/git-account/kbot/cmd.appVersion=${VERSION}" .

FROM ${BASE_IMAGE} as final
WORKDIR /
COPY --from=builder /kbot /kbot
ENTRYPOINT ["/kbot"]