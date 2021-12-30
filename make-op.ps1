$compress = @{
    Path = "./Oswald-Regular.ttf", "./DS-DIGIB.ttf", "./info.toml", "./src"
    CompressionLevel = "Fastest"
    DestinationPath = "../Odometer.zip"
}
Compress-Archive @compress -Force

Move-Item -Path "../Odometer.zip" -Destination "../Odometer.op" -Force

Write-Host("Done!")
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")