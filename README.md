<p align="center">
  <a href="https://lotus.filecoin.io/storage-providers/curio/overview/" title="Curio Docs">
    <img src="https://github.com/filecoin-project/curio/assets/63351350/a42a9baf-9091-4d3e-bb4b-088765ed8727" alt="Curio Logo" width="244" />
  </a>
</p>

<h1 align="center">Curio APT Repository</h1>

This is the official Debian APT repository for GPU-accelerated Filecoin software from [Curio Storage, Inc.](https://github.com/filecoin-project/curio), part of the [Filecoin Project](https://github.com/filecoin-project).

## 📦 Available Packages

The repository currently includes pre-built packages of **Curio**, the Filecoin storage engine, with GPU support:

- `curio-cuda` – Latest Curio build with **CUDA** support.
- `curio-opencl` – Latest Curio build with **OpenCL** support.

These packages allow you to run the latest version of Curio optimized for your specific GPU stack on Debian- or Ubuntu-based systems.

---

## 🚀 How to Use

1. **Add the GPG key:**

```bash
sudo wget -O /usr/share/keyrings/curiostorage-archive-keyring.gpg https://filecoin-project.github.io/apt/KEY.gpg
```

2.	**Add the APT repository:**
```
echo "deb [signed-by=/usr/share/keyrings/curiostorage-archive-keyring.gpg] https://filecoin-project.github.io/apt stable main" | sudo tee /etc/apt/sources.list.d/curiostorage.list
```
3.	**Update and install the desired Curio package:**
```
sudo apt update

sudo apt install curio-cuda     
# Or: sudo apt install curio-opencl
```
