import type { AnchorTypes } from "@saberhq/anchor-contrib";
import { PublicKey } from "@solana/web3.js";

import * as USE_INVALIDATOR_TYPES from "../../idl/cardinal_use_invalidator";

export const USE_INVALIDATOR_ADDRESS = new PublicKey(
  "Ea82cLwGjJgFNwvNqKW3bBHBefWmN2n36C7roQMeiY7R"
);

export const USE_INVALIDATOR_SEED = "use-invalidator";

export const USE_INVALIDATOR_IDL = USE_INVALIDATOR_TYPES.IDL;

export type USE_INVALIDATOR_PROGRAM =
  USE_INVALIDATOR_TYPES.CardinalUseInvalidator;

export type UseInvalidatorTypes = AnchorTypes<
  USE_INVALIDATOR_PROGRAM,
  {
    tokenManager: UseInvalidatorData;
  }
>;

type Accounts = UseInvalidatorTypes["Accounts"];
export type UseInvalidatorData = Accounts["useInvalidator"];
