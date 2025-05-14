use aiken/collection/list
use aiken/collection/dict
use aiken/crypto.{VerificationKeyHash}
use cardano/transaction.{ Transaction}
use cardano/assets.{PolicyId}

pub type Datum {
  owner: VerificationKeyHash,
}
 
validator one_owner_nft() {
  mint(
    datum: Option<Datum>,
    policy_id: PolicyId,
    self: Transaction
  ) {
    trace @"minting": policy_id, @"with", datum
    // check that the datum has the owners signature
    expect Some(Datum { owner }) = datum
    let must_be_signed = list.has(self.extra_signatories, owner)

    // It checks that only one minted asset exists and will fail otherwise
    // expect [Pair(_asset_name, quantity)] = self.mint
    //     |> assets.tokens(policy_id)
    //     |> dict.to_pairs()
    
    must_be_signed? // && (quantity == 1)?
  }

  // // Anything else fail
  // else(_) {
  //   fail
  // }
}

test one_owner_nft() {
  let datum = Datum { owner: #"00000000000000000000000000000000000000000000000000000000" }
  let policy_id = #"00000000000000000000000000000000000000000000000000000000"
 
  one_owner_nft.mint(
    Some(datum),
    policy_id,
    Transaction { ..transaction.placeholder, extra_signatories: [datum.owner] },
  )
}
 