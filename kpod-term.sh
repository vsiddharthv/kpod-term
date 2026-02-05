# Simple Windows-only Kubernetes exec helper
# Flow: Context → Namespace → Pod → Exec (/bin/bash)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Select-FromMenu {
    param(
        [string]$Prompt,
        [string[]]$Items
    )

    if (-not $Items -or $Items.Count -eq 0) {
        throw "No items found for: $Prompt"
    }

    Write-Host "`n$Prompt"
    for ($i = 0; $i -lt $Items.Count; $i++) {
        Write-Host " [$($i+1)] $($Items[$i])"
    }

    while ($true) {
        $choice = Read-Host "Enter choice (1-$($Items.Count))"
        if ($choice -match '^\d+$') {
            $index = [int]$choice - 1
            if ($index -ge 0 -and $index -lt $Items.Count) {
                return $Items[$index]
            }
        }
        Write-Host "Invalid choice, try again." -ForegroundColor Yellow
    }
}

# Ensure kubectl is available
if (-not (Get-Command kubectl -ErrorAction SilentlyContinue)) {
    throw "kubectl is not installed or not in PATH."
}

# --- CONTEXTS (clean names) ---
$contextsRaw = kubectl config get-contexts -o name 2>$null
if (-not $contextsRaw) { throw "No Kubernetes contexts found in your kubeconfig." }
$contexts = $contextsRaw -split "`r?`n" | Where-Object { $_.Trim() -ne "" }

$selectedContext = Select-FromMenu -Prompt "Select Kubernetes context" -Items $contexts
kubectl config use-context $selectedContext | Out-Null
Write-Host "Using context: $selectedContext" -ForegroundColor Cyan

# --- NAMESPACES (first column from table) ---
$namespaces = kubectl get ns --no-headers 2>$null | ForEach-Object {
    ($_ -split "\s+")[0]
} | Where-Object { $_.Trim() -ne "" } | Sort-Object

if (-not $namespaces -or $namespaces.Count -eq 0) {
    throw "Failed to list namespaces for context '$selectedContext'."
}

$selectedNs = Select-FromMenu -Prompt "Select namespace" -Items $namespaces
Write-Host "Using namespace: $selectedNs" -ForegroundColor Cyan

# --- PODS (first column from table) ---
$pods = kubectl get pods -n $selectedNs --no-headers 2>$null | ForEach-Object {
    ($_ -split "\s+")[0]
} | Where-Object { $_.Trim() -ne "" } | Sort-Object

if (-not $pods -or $pods.Count -eq 0) {
    throw "No pods found in namespace '$selectedNs'."
}

$selectedPod = Select-FromMenu -Prompt "Select pod" -Items $pods
Write-Host "Using pod: $selectedPod" -ForegroundColor Cyan

# --- EXEC: Straight to /bin/bash ---
Write-Host "Connecting: kubectl exec -it $selectedPod -n $selectedNs -- /bin/bash" -ForegroundColor Green
kubectl exec -it $selectedPod -n $selectedNs -- /bin/bash
