class Vela < Formula
  desc "Workspace manager UI for AI coding agents (Claude Code, Codex, Ralph Loop)"
  homepage "https://github.com/hardikshah197/Vela"
  version "1.0.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/hardikshah197/Vela/releases/download/v1.0.1/vela-1.0.1-darwin-arm64.tar.gz"
      sha256 "218d036a5d69e32a54b566e032f287e1e00029256f92f7f091921f688ae7133d"
    end

    on_intel do
      url "https://github.com/hardikshah197/Vela/releases/download/v1.0.1/vela-1.0.1-darwin-amd64.tar.gz"
      sha256 "fa3395cb7908696e4a1e21a5e731d7c656b56517c6e1fa49dcfb3630a302d8c9"
    end
  end

  def install
    bin.install "bin/vela-server"
    (share/"vela").install "share/vela/dist"

    # Create a convenience wrapper that starts the server
    (bin/"vela").write <<~EOS
      #!/bin/bash
      exec "#{bin}/vela-server" "$@"
    EOS
    chmod 0755, bin/"vela"
  end

  def caveats
    <<~EOS
      Vela is installed! Start the server with:

        vela

      Then open http://localhost:6100 in your browser.

      Configuration:
        Search roots:  Set via UI or VELA_SEARCH_ROOTS env var
        Clone dir:     Set via UI or VELA_CLONE_DIR env var
        Port:          Default 6100, override with PORT env var
        Auth config:   ~/.vela/auth.json

      Requires 'claude' or 'codex' CLI to be installed for the
      respective agent types.
    EOS
  end

  test do
    # Verify binary runs
    assert_match "Running on port", shell_output("#{bin}/vela-server &; sleep 2; kill %1 2>/dev/null; wait 2>/dev/null", 0)
  end
end
