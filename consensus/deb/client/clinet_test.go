package client

import (
	"context"
	"github.com/anduschain/go-anduschain-enterprise/accounts"
	"github.com/anduschain/go-anduschain-enterprise/common"
	"github.com/anduschain/go-anduschain-enterprise/core"
	"github.com/anduschain/go-anduschain-enterprise/core/types"
	"github.com/anduschain/go-anduschain-enterprise/p2p"
	proto "github.com/anduschain/go-anduschain-enterprise/protos/common"
	"testing"
	"time"
)

var client *DebClient
var tb *testBackend

type testBackend struct {
}

func (tb *testBackend) BlockChain() *core.BlockChain {
	return nil
}
func (tb *testBackend) AccountManager() *accounts.Manager {
	return nil
}
func (tb *testBackend) Server() *p2p.Server {
	return nil
}
func (tb *testBackend) Coinbase() common.Address {
	return common.Address{}
}

func init() {
	var err error
	client := NewDebClient(types.UNKNOWN_NETWORK)
	if client != nil {
		log.Error("new deb client", "msg", err)
	}
}

func TestNewDebClient(t *testing.T) {
	err := client.Start(tb)
	if err != nil {
		t.Errorf("deb client start msg = %t", err)
	}

	defer client.Stop()
}

func Test_Heartbeat(t *testing.T) {
	err := client.Start(tb)
	if err != nil {
		t.Errorf("deb client start msg = %t", err)
	}

	defer client.Stop()

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	msg := proto.HeartBeat{
		Enode:        "unit-test",
		ChainID:      "chain-id",
		MinerAddress: common.Address{}.String(),
		NodeVersion:  "node-version",
	}
	_, err = client.rpc.HeartBeat(ctx, &msg)
	if err != nil {
		t.Errorf("heartbeat call msg = %s", err.Error())
	}
}
