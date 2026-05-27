# homebrew-aspire (dogfood tap)

Personal Homebrew tap for **dogfooding** the [Aspire CLI](https://aspire.dev/)
Homebrew cask before the upstream
[`Homebrew/homebrew-cask`](https://github.com/Homebrew/homebrew-cask)
submission lands.

> ⚠️ **Not for production use.** This tap exists only to test the cask
> shape, validation gauntlet, and end-to-end install flow against
> Aspire CLI builds that don't yet have a GitHub release. Use the
> upstream cask (`brew install --cask aspire`) once 13.4 ships.

## Install

```bash
brew tap radical/aspire
brew install --cask radical/aspire/aspire
```

Uninstall and untap:

```bash
brew uninstall --cask radical/aspire/aspire
brew untap radical/aspire
```

## What's pinned

`Casks/aspire.rb` points at the **13.4 staging** Aspire CLI build hosted
on `ci.dot.net` — the same artifact that
`eng/scripts/get-aspire-cli.sh --quality staging` would download (aka.ms
staging URL resolves there). The cask hard-codes the resolved
ci.dot.net URL with a pinned SHA256 so `brew audit --cask --online`
treats it as a versioned URL and verifies integrity at install time.

For the same reason, `livecheck` is `skip`'d on this dogfood tap —
there's no GitHub release for 13.4 yet, so the
`:github_latest` strategy used by the upstream cask would resolve to a
stale 13.3 / 12.x tag.

## Source

This cask is derived from `eng/homebrew/aspire.rb.template` on the
`microsoft/aspire` `release/13.4` branch; the only substantive
differences are the URL host (`ci.dot.net` instead of
`github.com/.../releases/download/v#{version}`) and the `livecheck`
block (`skip` instead of `:github_latest`).
