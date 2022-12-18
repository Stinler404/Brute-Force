Clear-Host

$ErrorActionPreference = 'SilentlyContinue'

# Déclaration de la fonction du choix de l'utilisateur
function Select-FileDialog
{
 param([string]$Title,[string]$Directory,[string]$Filter="Fichier txt (*.txt)|*.txt")
 [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
 $objForm = New-Object System.Windows.Forms.OpenFileDialog
 $objForm.InitialDirectory = $Directory
 $objForm.Filter = $Filter
 $objForm.Title = $Title
 $Show = $objForm.ShowDialog()
 If ($Show -eq "OK")
 {
  Return $objForm.FileName
 }
 Else
 {
  Break
 }
 }

# Bannière d'affichage
Write-Host "------------------- MD5 Brute Force -------------------"
Write-Host "`n"

# Demandez à l'utilisateur d'entrer la clé MD5
$targetHash = Read-Host "Entrez la clé MD5 à déchiffrer "

# Demandez à l'utilisateur de choisir son dictionnaire
$dic_path = Select-FileDialog -Title "Selectionnez votre dictionnaire"

# Ouvrez le dictionnaire
$lines = Get-Content -Path $dic_path

# Itérez sur chaque ligne du dictionnaire
foreach($line in $lines)
{

  # Calculez le hash de la ligne
  $hash = [System.BitConverter]::ToString((New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider).ComputeHash([System.Text.Encoding]::UTF8.GetBytes($line)))
  $hash.ToString() | Out-Null
  $hash = $hash.Replace("-","") 

  # Si le hash correspond à la clé cible, affichez le message
  if($hash.ToLower() -eq $targetHash)
  {
    Write-Output "`n"
    Write-Host "Mot de passe déchiffré : $line" -ForegroundColor Green
    Write-Output "`n"
    Read-Host "Appuyez sur une touche pour quitter "
    Exit
  }
  else
  {
    Write-Output "`n"
    Write-Host "La clé $targetHash n'a pas pu être déchiffré" -ForegroundColor Red
    Write-Output "`n"
    Read-Host "Appuyez sur une touche pour quitter "
    Exit
  }
}
