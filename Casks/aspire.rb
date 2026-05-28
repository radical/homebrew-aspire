cask "aspire" do
  arch arm: "arm64", intel: "x64"

  version "13.4.0-preview.1.26277.18"
  sha256 arm:   "8c5d2e281924e493fd2399f9e47a33c979b6d803a861274300c86e6852383f72",
         intel: "26ec5079f6c9972fe834b1b23750e3cafecfd0d48fffd8d5d58be64807f5b3d6"

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
