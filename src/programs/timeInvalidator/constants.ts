import type { AnchorTypes } from "@saberhq/anchor-contrib";
import { PublicKey } from "@solana/web3.js";

import * as TIME_INVALIDATOR_TYPES from "../../idl/cardinal_time_invalidator";

export const TIME_INVALIDATOR_ADDRESS = new PublicKey(
  "AmoML37av2K7Cn4p5s2uYvdftC6v47RQveaAD1vPEGck"
);

export const TIME_INVALIDATOR_SEED = "time-invalidator";

export const TIME_INVALIDATOR_IDL = TIME_INVALIDATOR_TYPES.IDL;

export type TIME_INVALIDATOR_PROGRAM =
  TIME_INVALIDATOR_TYPES.CardinalTimeInvalidator;

export type TimeInvalidatorTypes = AnchorTypes<
  TIME_INVALIDATOR_PROGRAM,
  {
    tokenManager: TimeInvalidatorData;
  }
>;

type Accounts = TimeInvalidatorTypes["Accounts"];
export type TimeInvalidatorData = Accounts["timeInvalidator"];
