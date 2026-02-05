# **kpod-term – Simple PowerShell Helper for Quickly Executing Into Kubernetes Pods**

`kpod-term.ps1` is a lightweight, Windows‑only PowerShell utility that lets you quickly:

1.  Select a **Kubernetes context**
2.  Select a **namespace**
3.  Select a **pod**
4.  Automatically run
        kubectl exec -it <pod> -n <namespace> -- /bin/bash

No UI components. No external dependencies.  
Just clean console menus and a straightforward workflow that works reliably on **Windows 10/11 PowerShell**.

***

## 🚀 Features

*   ✔ Pure PowerShell (no JSONPath, no fzf, no UI popups)
*   ✔ Works on **Windows PowerShell** and **PowerShell 7+**
*   ✔ Fast pod selection using console menus
*   ✔ Automatically connects to `/bin/bash` inside the container
*   ✔ Ideal for developers/SREs who frequently jump into pods

***

## 📥 Installation

### 1. **Clone this repository**

```powershell
git clone https://github.com/<your-username>/<your-repo>.git
```

### 2. **Place the script in a folder included in your PATH**

The recommended folder is:

    C:\Users\<your-username>\Documents\WindowsPowerShell\Scripts

If the folder doesn’t exist — create it.

### 3. **Add the folder to your PATH, if not already present**

Run this in PowerShell:

```powershell
[Environment]::SetEnvironmentVariable(
    "Path",
    $env:Path + ";$HOME\Documents\WindowsPowerShell\Scripts",
    "User"
)
```

Restart PowerShell after setting PATH.

***

## 🏃 Usage

Once the script is in your PATH, you can run it from **any folder**:

```powershell
kpod-term
```

Or, if you kept the `.ps1` extension:

```powershell
kpod-term.ps1
```

The script will guide you through:

1.  Selecting a Kubernetes **context**
2.  Selecting a **namespace**
3.  Selecting a **pod**
4.  Automatically connecting via:

<!---->

    kubectl exec -it <pod> -n <namespace> -- /bin/bash

***

## 📌 Prerequisites

*   **kubectl** installed and configured
*   Access to the Kubernetes clusters/contexts you want to use
*   PowerShell execution policy allowing your script

If blocked, run:

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

***

## 🧩 Example Session

    Select Kubernetes context
     [1] aksnonprode2e02
     [2] aksprode2e01
    Enter choice (1-2): 1

    Select namespace
     [1] default
     [2] kube-system
    Enter choice (1-2): 2

    Select pod
     [1] coredns-6d4b75cb6d-rk2mt
    Enter choice (1): 1

    Connecting: kubectl exec -it coredns-6d4b75cb6d-rk2mt -n kube-system -- /bin/bash

***

## 🔧 Customization

You can easily modify the script to:

*   Filter pods by label
*   Automatically select namespaces
*   Add fallback to `/bin/sh`
*   Include container selection (if needed)

***

## 🤝 Contributing

Pull requests, improvements, and suggestions are welcome!  
If you’d like enhancements (e.g., auto‑label filtering, favorite namespaces, aliases), feel free to open an issue.
