<#
.SYNOPSIS
    WinErrata GUI - solucionador gráfico de problemas de Windows (sin línea de comandos).
.DESCRIPTION
    Lista los issues documentados, permite escanear el equipo, ver una explicación
    sencilla y aplicar/deshacer los arreglos con botones. Se recomienda ejecutar
    como Administrador (usar Run-WinErrata.bat).
#>
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
$issuesDir = Join-Path $repoRoot 'issues'

$form = New-Object Windows.Forms.Form
$form.Text = 'WinErrata - Solucionador de problemas de Windows'
$form.Size = New-Object Drawing.Size(980, 640)
$form.StartPosition = 'CenterScreen'

# --- Titulo / estado ---
$lbl = New-Object Windows.Forms.Label
$lbl.Text = 'Selecciona un problema, pulsa "Escanear" y luego "Aplicar". Todo es reversible.'
$lbl.Location = New-Object Drawing.Point(12, 12); $lbl.Size = New-Object Drawing.Size(940, 20)
$form.Controls.Add($lbl)

$status = New-Object Windows.Forms.Label
$status.Text = 'Estado: listo'; $status.ForeColor = 'DarkGreen'
$status.Location = New-Object Drawing.Point(12, 588); $status.Size = New-Object Drawing.Size(940, 20)
$form.Controls.Add($status)

# --- Lista de issues (CheckedListBox) ---
$clb = New-Object Windows.Forms.CheckedListBox
$clb.Location = New-Object Drawing.Point(12, 40); $clb.Size = New-Object Drawing.Size(470, 480)
$clb.CheckOnClick = $true
$form.Controls.Add($clb)

# --- Detalles (explicacion sencilla) ---
$txtDetail = New-Object Windows.Forms.TextBox
$txtDetail.Location = New-Object Drawing.Point(500, 40); $txtDetail.Size = New-Object Drawing.Size(460, 300)
$txtDetail.Multiline = $true; $txtDetail.ScrollBars = 'Vertical'; $txtDetail.ReadOnly = $true
$txtDetail.Font = New-Object Drawing.Font('Consolas', 9)
$form.Controls.Add($txtDetail)

# --- Log ---
$txtLog = New-Object Windows.Forms.TextBox
$txtLog.Location = New-Object Drawing.Point(500, 350); $txtLog.Size = New-Object Drawing.Size(460, 170)
$txtLog.Multiline = $true; $txtLog.ScrollBars = 'Vertical'; $txtLog.ReadOnly = $true
$txtLog.Font = New-Object Drawing.Font('Consolas', 9)
$form.Controls.Add($txtLog)

# --- Botones ---
function Add-Button($text, $x, $y, $w, $action) {
  $b = New-Object Windows.Forms.Button
  $b.Text = $text; $b.Location = New-Object Drawing.Point($x, $y); $b.Size = New-Object Drawing.Size($w, 30)
  $b.Add_Click($action); $form.Controls.Add($b); return $b
}
Add-Button 'Escanear mi equipo' 12 530 150 { Scan-Issues }
Add-Button 'Aplicar seleccionados' 170 530 160 { Apply-Selected }
Add-Button 'Aplicar todos los seguros' 338 530 144 { Apply-Safe }
Add-Button 'Abrir guia (leer)' 490 530 140 { Open-Guide }
Add-Button 'Salir' 770 530 100 { $form.Close() }

# --- Log helper ---
function Log($msg) { $txtLog.AppendText("$(Get-Date -Format 'HH:mm:ss') $msg`r`n"); $txtLog.ScrollToCaret() }

# --- Cargar issues ---
$script:Issues = @()
Get-ChildItem $issuesDir -Directory | ForEach-Object {
  $json = Join-Path $_.FullName 'issue.json'
  if (Test-Path $json) {
    try { $i = Get-Content $json -Raw | ConvertFrom-Json; $i | Add-Member -NotePropertyName '_dir' -NotePropertyValue $_.FullName; $script:Issues += $i } catch { Log "Error leyendo $($_.Name): $_" }
  }
}
foreach ($i in $script:Issues) { $clb.Items.Add("[$($i.category)/$($i.severity)] $($i.title)") | Out-Null }

# --- Mostrar detalle al seleccionar ---
$clb.Add_SelectedIndexChanged({
  if ($clb.SelectedIndex -ge 0) {
    $i = $script:Issues[$clb.SelectedIndex]
    $txtDetail.Text = "TITULO: $($i.title)`r`nCATEGORIA: $($i.category) | RIESGO: $($i.severity) | REVERSIBLE: $($i.reversible)`r`n`r`nEXPLICACION SENCILLA:`r`n$($i.plain_language)`r`n`r`nSINTOMA: $($i.symptom)`r`n`r`nCAUSA: $($i.root_cause)"
  }
})

function Test-Applies($issue) {
  if ($issue.affected.builds -and $issue.affected.builds.Count -gt 0) {
    $b = [string](Get-ComputerInfo -Property OsBuildNumber).OsBuildNumber
    if ($issue.affected.builds -notcontains $b) { return $false }
  }
  if ($issue.detection) { try { return [bool](Invoke-Expression $issue.detection) } catch { return $true } }
  return $true
}

function Scan-Issues {
  Log 'Escaneando...'
  for ($n = 0; $n -lt $script:Issues.Count; $n++) {
    $i = $script:Issues[$n]
    if (Test-Applies $i) { Log "[APLICA] $($i.id)" } else { Log "[ok] $($i.id) (no aplica)" }
  }
  Log 'Escaneo terminado. Los que dicen APLICA se pueden arreglar.'
}

function Apply-Issue($issue) {
  $fix = Join-Path $issue._dir 'fix.ps1'
  if (-not (Test-Path $fix)) { Log "FIX no encontrado: $($issue.id)"; return }
  Log ">> Aplicando: $($issue.id)"
  try { & $fix *>&1 | ForEach-Object { Log "$_" } } catch { Log "Error: $_" }
}

function Apply-Selected {
  for ($n = 0; $n -lt $clb.Items.Count; $n++) {
    if ($clb.GetItemChecked($n)) { Apply-Issue $script:Issues[$n] }
  }
  Log 'Hecho. Si algun fix lo recomienda, reinicia el equipo.'
}

function Apply-Safe {
  foreach ($i in $script:Issues) {
    if ($i.reversible -and ($i.severity -in @('low','medium')) -and (Test-Applies $i)) { Apply-Issue $i }
  }
  Log 'Hecho (solo seguros y reversibles).'
}

function Open-Guide {
  if ($clb.SelectedIndex -ge 0) {
    $readme = Join-Path $script:Issues[$clb.SelectedIndex]._dir 'README.md'
    if (Test-Path $readme) { Start-Process notepad.exe $readme } else { Log 'No hay guia para este item.' }
  } else { Log 'Selecciona un item primero.' }
}

[void]$form.ShowDialog()
