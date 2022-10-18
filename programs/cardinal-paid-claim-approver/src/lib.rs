pub mod errors;
pub mod instructions;
pub mod state;

use {anchor_lang::prelude::*, instructions::*};

declare_id!("3GT5Q6wwXwfDUcMAn6h4XCtmqSVFLp9eL7WQjKshNK3L");

#[program]
pub mod cardinal_paid_claim_approver {
    use super::*;

    pub fn init(ctx: Context<InitCtx>, ix: InitIx) -> Result<()> {
        init::handler(ctx, ix)
    }

    pub fn pay<'key, 'accounts, 'remaining, 'info>(ctx: Context<'key, 'accounts, 'remaining, 'info, PayCtx<'info>>) -> Result<()> {
        pay::handler(ctx)
    }

    pub fn close(ctx: Context<CloseCtx>) -> Result<()> {
        close::handler(ctx)
    }
}
