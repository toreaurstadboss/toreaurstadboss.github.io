# toreaurstadboss.github.io

_Github pages repo for Tore Aurstad (GitHub username : @toreaurstadboss)_

## Web link to Github Pages - Tore Aurstad


https://toreaurstadboss.github.io/

## Welcome to my lectures!


### Choose a lecture!

* [Lecture 1 - Programmatic MCP Demo](lectures/lecture1/ProgrammaticMcpDemo.md)
* [Lecture 2 - ApiResult Monad with C# 15 Union Types](lectures/lecture2/ApiResultMonad.md)
* [Lecture 3 - Local Snowstorm SNOMED CT Server](lectures/lecture3/Snowstorm.md)


<img src="assets/images/professor_lecturer_cats_university.png" width="600" alt="Professor Catiana Doges" />

## Preview locally on Windows

GitHub Pages uses Jekyll. You do not need WSL or Docker. This setup uses the `github-pages` gem and Bundler, following the [GitHub guide](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/testing-your-github-pages-site-locally-with-jekyll).

### First-time setup

1. Install **Ruby+Devkit 3.1 (x64)** from the [RubyInstaller archives](https://rubyinstaller.org/downloads/archives/). GitHub notes that newer Ruby versions can have compatibility issues with the Pages gem. Ruby 3.1 is end-of-life; use it for this local preview, not production services.
2. During installation, add Ruby to `PATH` and complete the MSYS2 setup. MSYS2 supplies the compiler needed by some gems. If necessary, run `ridk install` and select the MSYS2 base installation and development toolchain.
3. Open a new PowerShell terminal in the repository folder and verify `ruby --version`. Then install the dependencies:

```powershell
bundle config set --local build.bigdecimal --with-cflags=-Wno-error=incompatible-pointer-types
bundle config set --local build.http_parser.rb --with-cflags=-Wno-error=incompatible-pointer-types
bundle config set --local build.racc --with-cflags=-Wno-error=incompatible-pointer-types
bundle config set --local build.openssl --with-cflags=-Wno-error=incompatible-pointer-types
bundle install
```

The build flags work around Ruby 3.1 native-extension errors with newer MSYS2 compilers. Bundler stores these settings locally in `.bundle/`. If `bundle` is unavailable, install it with `gem install bundler`.

On this computer Ruby was unpacked under `%LOCALAPPDATA%\GitHubPagesRuby31\rubyinstaller-3.1.7-1-x64`; the VS Code task also checks that location. In a separate PowerShell terminal, add its `bin` directory to the session's `PATH` before running the commands above:

```powershell
$env:PATH = "$env:LOCALAPPDATA\GitHubPagesRuby31\rubyinstaller-3.1.7-1-x64\bin;$env:PATH"
```

### Start the preview

In VS Code, choose **Run and Debug** > **Preview GitHub Pages** and press `F5`. The task runs [Start-GitHubPages.ps1](.vscode/Start-GitHubPages.ps1), which displays a Ruby banner, checks the bundle, and starts Jekyll. Once the server is ready, VS Code opens Microsoft Edge. Stop the Jekyll task from **Terminal: Terminate Task** when finished.

Alternatively, run this from the repository folder:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\.vscode\Start-GitHubPages.ps1
```

Open [http://127.0.0.1:4000/](http://127.0.0.1:4000/) or the [lecture 3 menu](http://127.0.0.1:4000/lectures/lecture3/Snowstorm.html). To use another port from the terminal, add `-Port 4001` to the command and open `http://127.0.0.1:4001/`. The VS Code launch configuration uses port 4000.

Jekyll rebuilds changed pages while running; restart it after changing `_config.yml`. Press `Ctrl+C` to stop the terminal server. Lecture 3's blog images require an internet connection.
