# This Makefile is meant to be used by people that do not usually work
# with Go source code. If you know what GOPATH is then you probably
# don't need to bother with make.

.PHONY: godaon-enterprise android ios godaon-enterprise-cross evm all test clean
.PHONY: godaon-enterprise-linux godaon-enterprise-linux-386 godaon-enterprise-linux-amd64 godaon-enterprise-linux-mips64 geth-linux-mips64le
.PHONY: godaon-enterprise-linux-arm geth-linux-arm-5 godaon-enterprise-linux-arm-6 godaon-enterprise-linux-arm-7 godaon-enterprise-linux-arm64
.PHONY: godaon-enterprise-darwin godaon-enterprise-darwin-386 godaon-enterprise-darwin-amd64
.PHONY: godaon-enterprise-windows godaon-enterprise-windows-386 godaon-enterprise-windows-amd64
.PHONY: fairnode loadtest bootnode-linux-amd64 proto

GOBIN = $(shell pwd)/build/bin
GO ?= latest

godaon-enterprise:
	build/env.sh go run build/ci.go install ./cmd/godaon-enterprise
	@echo "Done building godaon-enterprise."
	@echo "Run \"$(GOBIN)/godaon\" to launch godaon-enterprise."

fairnode:
	build/env.sh go run build/ci.go install ./cmd/fairnode
	@echo "Done building fairnode."
	@echo "Run \"$(GOBIN)/fairnode\" to launch fairnode."


loadtest:
	build/env.sh go run build/ci.go install ./cmd/loadtest
	@echo "Done building loadtest."
	@echo "Run \"$(GOBIN)/loadtest\" to launch loadtest."

all:
	build/env.sh go run build/ci.go install
	@echo "Done building all."

android:
	build/env.sh go run build/ci.go aar --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/geth.aar\" to use the library."

ios:
	build/env.sh go run build/ci.go xcode --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/Geth.framework\" to use the library."

test: all
	build/env.sh go run build/ci.go test

lint: ## Run linters.
	build/env.sh go run build/ci.go lint

proto:
	build/proto_build.sh
	@echo "Done building proto file."

clean:
	./build/clean_go_build_cache.sh
	rm -fr build/_workspace/pkg/ $(GOBIN)/*

# The devtools target installs tools required for 'go generate'.
# You need to put $GOBIN (or $GOPATH/bin) in your PATH to use 'go generate'.

devtools:
	env GOBIN= go get -u golang.org/x/tools/cmd/stringer
	env GOBIN= go get -u github.com/kevinburke/go-bindata/go-bindata
	env GOBIN= go get -u github.com/fjl/gencodec
	env GOBIN= go get -u github.com/golang/protobuf/protoc-gen-go
	env GOBIN= go install ./cmd/abigen
	@type "npm" 2> /dev/null || echo 'Please install node.js and npm'
	@type "solc" 2> /dev/null || echo 'Please install solc'
	@type "protoc" 2> /dev/null || echo 'Please install protoc'

# Cross Compilation Targets (xgo)

# loadtest
loadtest-linux-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/amd64 -v ./cmd/loadtest
	@echo "Linux amd64 cross compilation done:"
	@ls -ld $(GOBIN)/loadtest-linux-* | grep amd64

# fairnode
fairnode-linux-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/amd64 -v ./cmd/fairnode
	@echo "Linux amd64 cross compilation done:"
	@ls -ld $(GOBIN)/fairnode-linux-* | grep amd64

# bootnode
bootnode-linux-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/amd64 -v ./cmd/bootnode
	@echo "Linux amd64 cross compilation done:"
	@ls -ld $(GOBIN)/bootnode-linux-* | grep amd64

godaon-enterprise-cross: godaon-enterprise-linux godaon-enterprise-darwin godaon-enterprise-windows godaon-enterprise-android godaon-enterprise-ios
	@echo "Full cross compilation done:"
	@ls -ld $(GOBIN)/godaon-enterprise-*

godaon-enterprise-linux: godaon-enterprise-linux-386 godaon-enterprise-linux-amd64 godaon-enterprise-linux-arm godaon-enterprise-linux-mips64 godaon-enterprise-linux-mips64le
	@echo "Linux cross compilation done:"
	@ls -ld $(GOBIN)/godaon-enterprise-linux-*

godaon-enterprise-bundle: godaon-enterprise-linux-386 godaon-enterprise-linux-amd64 godaon-enterprise-darwin-amd64 godaon-enterprise-windows-386 godaon-enterprise-windows-amd64
	@echo "Bundle cross compilation done:"
	@ls -ld $(GOBIN)/godaon-enterprise-*

godaon-enterprise-linux-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/386 -v ./cmd/godaon-enterprise
	@echo "Linux 386 cross compilation done:"
	@ls -ld $(GOBIN)/godaon-enterprise-linux-* | grep 386

godaon-enterprise-linux-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/amd64 -v ./cmd/godaon-enterprise
	@echo "Linux amd64 cross compilation done:"
	@ls -ld $(GOBIN)/godaon-enterprise-linux-* | grep amd64

godaon-enterprise-linux-arm: godaon-enterprise-linux-arm-5 godaon-enterprise-linux-arm-6 godaon-enterprise-linux-arm-7 godaon-enterprise-linux-arm64
	@echo "Linux ARM cross compilation done:"
	@ls -ld $(GOBIN)/godaon-enterprise-linux-* | grep arm

godaon-enterprise-linux-arm-5:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-5 -v ./cmd/godaon-enterprise
	@echo "Linux ARMv5 cross compilation done:"
	@ls -ld $(GOBIN)/godaon-enterprise-linux-* | grep arm-5

godaon-enterprise-linux-arm-6:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-6 -v ./cmd/godaon-enterprise
	@echo "Linux ARMv6 cross compilation done:"
	@ls -ld $(GOBIN)/godaon-enterprise-linux-* | grep arm-6

godaon-enterprise-linux-arm-7:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-7 -v ./cmd/godaon-enterprise
	@echo "Linux ARMv7 cross compilation done:"
	@ls -ld $(GOBIN)/godaon-enterprise-linux-* | grep arm-7

godaon-enterprise-linux-arm64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm64 -v ./cmd/godaon-enterprise
	@echo "Linux ARM64 cross compilation done:"
	@ls -ld $(GOBIN)/godaon-enterprise-linux-* | grep arm64

godaon-enterprise-linux-mips:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips --ldflags '-extldflags "-static"' -v ./cmd/godaon-enterprise
	@echo "Linux MIPS cross compilation done:"
	@ls -ld $(GOBIN)/godaon-enterprise-linux-* | grep mips

godaon-enterprise-linux-mipsle:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mipsle --ldflags '-extldflags "-static"' -v ./cmd/godaon-enterprise
	@echo "Linux MIPSle cross compilation done:"
	@ls -ld $(GOBIN)/godaon-enterprise-linux-* | grep mipsle

godaon-enterprise-linux-mips64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64 --ldflags '-extldflags "-static"' -v ./cmd/godaon-enterprise
	@echo "Linux MIPS64 cross compilation done:"
	@ls -ld $(GOBIN)/godaon-enterprise-linux-* | grep mips64

godaon-enterprise-linux-mips64le:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64le --ldflags '-extldflags "-static"' -v ./cmd/godaon-enterprise
	@echo "Linux MIPS64le cross compilation done:"
	@ls -ld $(GOBIN)/godaon-enterprise-linux-* | grep mips64le

godaon-enterprise-darwin: godaon-enterprise-darwin-386 godaon-enterprise-darwin-amd64
	@echo "Darwin cross compilation done:"
	@ls -ld $(GOBIN)/godaon-enterprise-darwin-*

godaon-enterprise-darwin-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/386 -v ./cmd/godaon-enterprise
	@echo "Darwin 386 cross compilation done:"
	@ls -ld $(GOBIN)/godaon-enterprise-darwin-* | grep 386

godaon-enterprise-darwin-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/amd64 -v ./cmd/godaon-enterprise
	@echo "Darwin amd64 cross compilation done:"
	@ls -ld $(GOBIN)/godaon-enterprise-darwin-* | grep amd64

godaon-enterprise-windows: godaon-enterprise-windows-386 godaon-enterprise-windows-amd64
	@echo "Windows cross compilation done:"
	@ls -ld $(GOBIN)/godaon-enterprise-windows-*

godaon-enterprise-windows-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/386 -v ./cmd/godaon-enterprise
	@echo "Windows 386 cross compilation done:"
	@ls -ld $(GOBIN)/godaon-enterprise-windows-* | grep 386

godaon-enterprise-windows-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/amd64 -v ./cmd/godaon-enterprise
	@echo "Windows amd64 cross compilation done:"
	@ls -ld $(GOBIN)/godaon-enterprise-windows-* | grep amd64
