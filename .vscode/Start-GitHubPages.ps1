param(
    [ValidateRange(1, 65535)]
    [int]$Port = 4000
)

Set-Location (Join-Path $PSScriptRoot '..')

Write-Host @'
       .-""-.
      / /\   \
     /_/__\___\
     \ \  /  /
      \ \/  /
       \___/
'@ -ForegroundColor Red
Write-Host '       RUBY  +  JEKYLL' -ForegroundColor Magenta
Write-Host '       GitHub Pages local preview' -ForegroundColor Cyan
Write-Host ''

Write-Host '[1/3] Preparing the preview' -ForegroundColor Cyan
$rubyBin = Join-Path $env:LOCALAPPDATA 'GitHubPagesRuby31\rubyinstaller-3.1.7-1-x64\bin'
if (Test-Path $rubyBin)
{
    $env:PATH = "$rubyBin;$env:PATH"
}

if (-not (Get-Command bundle -ErrorAction SilentlyContinue))
{
    Write-Host 'Bundler not found. See README for setup.' -ForegroundColor Red
    exit 1
}

ruby --version
Write-Host '[2/3] Checking site dependencies' -ForegroundColor Cyan
bundle check
if ($LASTEXITCODE -ne 0)
{
    Write-Host 'Installing missing gems...' -ForegroundColor Yellow
    bundle install
    if ($LASTEXITCODE -ne 0)
    {
        Write-Host 'Dependency installation failed.' -ForegroundColor Red
        exit $LASTEXITCODE
    }
}

Write-Host '[3/3] Building site and starting Jekyll...' -ForegroundColor Green
Write-Host 'Build details and preview URL follow:' -ForegroundColor Cyan
bundle exec jekyll serve --host 127.0.0.1 --port $Port --force_polling
exit $LASTEXITCODE