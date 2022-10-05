import type { AnchorTypes } from "@saberhq/anchor-contrib";
import { PublicKey } from "@solana/web3.js";

import * as USE_INVALIDATOR_TYPES from "../../idl/cardinal_use_invalidator";

export const USE_INVALIDATOR_ADDRESS = new PublicKey(
  "CrqZJ1frYpEvmJDR4zKpJNicrPDNwKKUKevetmk7Eajo"
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
