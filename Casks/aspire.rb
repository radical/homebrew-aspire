cask "aspire" do
  arch arm: "arm64", intel: "x64"

  version "13.4.0-preview.1.26278.17"
  sha256 arm:   "640efd6e1c58d93ff9786595233541febac0ba80a166c6d8928ec0fcf663f451",
         intel: "19cb6a3579162525f80b71f185eb9bea6c10515f9c020441b61c57ef90d18da5"

  url "https://ci.dot.net/public/aspire/#{version}/aspire-cli-osx-#{arch}-13.4.0.tar.gz",
      verified: "ci.dot.net/public/aspire/"
  name "Aspire CLI"
  desc "CLI for building observable, production-ready distributed applications"
  homepage "https://aspire.dev/"

  # Skip livecheck on this staging dogfood tap; the daily staging channel does
  # not have a stable version surface, and the upstream Homebrew/homebrew-cask
  # submission will use the real livecheck block from
  # eng/homebrew/aspire.rb.template.
  livecheck do
    skip "Aspire 13.4 staging dogfood; tracks the aka.ms/dotnet/9/aspire/rc/daily channel."
  end

  depends_on :macos

  binary "aspire"

  # Lets the Aspire CLI identify the install source without path heuristics.
  postflight do
    File.write("#{staged_path}/.aspire-install.json", %Q({"source":"brew"}\n))
  end

  uninstall_preflight do
    [
      "#{caskroom_path}/.aspire-bundle-version",
      "#{caskroom_path}/bundle",
      *Pathname.glob("#{caskroom_path}/versions/#{version}_*"),
    ].each { |path| FileUtils.rm_r(path, force: true) }
    versions_dir = Pathname("#{caskroom_path}/versions")
    versions_dir.rmdir if versions_dir.directory? && versions_dir.children.empty?
  end

  zap trash: []
end
