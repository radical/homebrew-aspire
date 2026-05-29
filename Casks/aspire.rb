cask "aspire" do
  arch arm: "arm64", intel: "x64"

  version "13.4.0"
  sha256 arm:   "6aca9af53c351e1ae5aea8f66f57cb0be794dfe7d854088f91c4155d32c90225",
         intel: "dae471370bf3915e8245e5e42cfd84da7aac1e1de797d9e0d4c0cb61170fbe6b"

  url "https://ci.dot.net/public/aspire/13.4.0-preview.1.26279.5/aspire-cli-osx-#{arch}-#{version}.tar.gz",
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
