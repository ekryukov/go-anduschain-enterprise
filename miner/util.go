package miner

import (
	"github.com/anduschain/go-anduschain-enterprise/common"
	"github.com/anduschain/go-anduschain-enterprise/crypto/sha3"
	"github.com/anduschain/go-anduschain-enterprise/rlp"
)

func rlpHash(x interface{}) (h common.Hash) {
	hw := sha3.NewKeccak256()
	rlp.Encode(hw, x)
	hw.Sum(h[:0])
	return h
}
