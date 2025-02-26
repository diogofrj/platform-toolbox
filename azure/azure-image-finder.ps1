#####   FILENAME:           azure-image-finder.ps1
#####   VERSION:            1.0
#####   DESCRIPTION:        Procura por Imagens disponiveis no Azure por localidade
#####   CREATION DATE:      26/02/2025
#####   WRITTEN BY:         Diogo Fernandes @diogofrj 🐙"
#####   E-MAIL:             dfs@outlook.com.br
#####   DISTRIBUTION:       N/A
#####   REFERENCE:          https://docs.microsoft.com/pt-br/azure/virtual-machines/scripts/virtual-machines-powershell-sample-copy-managed-disks-vhd
#####   USAGE:              .\azure-image-finder.ps1 -Location eastus -ImageSku windows


Param (
    [Parameter(Mandatory = $True)]
    [string]$ImageSku,
    [Parameter(Mandatory = $False)]
    [string]$Location = "brazilsouth"  # Região default caso o usuário não digite nada
)

$publisher = Get-AzVMImagePublisher -Location $Location | where-object { $_.PublisherName -like "*$ImageSku*" } | ft PublisherName, Location
if ($publisher -eq $null) {
    Write-Host "Resultado vazio, tente outro nome." -ForegroundColor Green
    exit
}
$publisher
$pubName = Read-Host "Please enter Publisher Name............"
Get-AzVMImageOffer -Location $Location -PublisherName $pubName | Format-Table -AutoSize
$offerName = Read-Host "Please enter Offer Name............"
Get-AzVMImageSku -Location $Location -PublisherName $pubName -Offer $offerName | Format-Table -AutoSize
$skuName = Read-Host "Please enter SKU Name............"
Get-AzVMImage -Location $Location -PublisherName $pubName -Skus $skuName -Offer $offerName | Format-Table -AutoSize


Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------------------" -ForegroundColor White
Write-Host "URN.........:"$pubName":"$offerName":"$skuName":"Latest"" -ForegroundColor Green "`n"
Write-Host "CLI.........:" 
Write-Host "az group create --name RG-FASTVM --location $Location" -ForegroundColor Blue
Write-Host "az vm create --resource-group RG-FASTVM --name VM-FAST --location $Location --image"$pubName":"$offerName":"$skuName":"Latest" --size Standard_d4as_v4" --admin-username "useradmin" --admin-password "Sua_S3nha_Segura123" "`n" -ForegroundColor Blue
Write-Host "Powershell..:" 
Write-Host '$securePassword = ConvertTo-SecureString "Sua_S3nha_Segura123" -AsPlainText -Force' -ForegroundColor DarkCyan
Write-Host '$credential = New-Object System.Management.Automation.PSCredential("useradmin", $securePassword)' -ForegroundColor DarkCyan
Write-Host "New-AzResourceGroup -Name RG-FASTVM -Location $Location" -ForegroundColor DarkCyan
Write-Host "New-AzVm -ResourceGroupName RG-FASTVM -Name VM-FAST -Location $Location -ImageName "$pubName":"$offerName":"$skuName":"Latest" -Size Standard_d4as_v4 -Credential `$credential" -ForegroundColor DarkCyan "`n"

Write-Host "Terraform...:" -ForegroundColor Magenta
Write-Host "source_image_reference {"
Write-Host "    publisher = "$pubName""
Write-Host "    offer     = "$offerName""
Write-Host "    sku       = "$skuName""
Write-Host "    version   = "latest""
Write-Host "  }" "`n"

