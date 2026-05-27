cask "aspire" do
  arch arm: "arm64", intel: "x64"

  version "13.4.0-preview.1.26277.9"
  sha256 arm:   "093551597188d389e96e97579dc48d6ddcd1207df136277ca8f09438e43d1cf6",
         intel: "e84ac7a91dfcff2f106767ecdb2dcd9d18bc97692ace3ab8cef7b6a28298f474"

  url "https://ci.dot.net/public/aspire/#{version}/aspire-cli-osx-#{arch}-13.4.0.tar.gz",
      verified: "ci.dot.net/public/aspire/"
  name "Aspire CLI"
  desc "CLI for building observable, production-ready distributed applications"
  homepage "https://aspire.dev/"

  # Dogfood tap for the 13.4 staging build. There is no GitHub release for
  # 13.4 yet, so the :github_latest strategy used by the upstream cask would
  # resolve to an older 13.3 / 12.x tag — wrong for this version. Skip
  # livecheck entirely on this dogfood tap; the upstream Homebrew/homebrew-cask
  # submission will use the real livecheck block from
  # eng/homebrew/aspire.rb.template.
  livecheck do
    skip "Aspire 13.4 staging dogfood; no upstream release for this version yet."
  end

  depends_on :macos

  binary "aspire"

  postflight do
    File.write("#{staged_path}/.aspire-install.json", %Q({"source":"brew"}\n))
  end

  zap trash: []
end
