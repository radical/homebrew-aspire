cask "aspire" do
  arch arm: "arm64", intel: "x64"

  version "13.4.0"
  sha256 arm:   "041e6998f1cdfb43ba7aef8ae7fadc020d1bc413277a387acbe0393481f22105",
         intel: "ca84fd9916021ea2c42b770f28be62ce0717f8dbe62213453439b62296038ae4"

  url "https://ci.dot.net/public/aspire/13.4.0-preview.1.26280.4/aspire-cli-osx-#{arch}-#{version}.tar.gz",
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
