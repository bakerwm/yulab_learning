





```
# user info
username: lijunxi
passwd: ********
host:   ********
port:   22

home: /home/lijunxi
public_data: /data/biodata/genome/
public_soft: /data/biosoft/
```



## I. Requirements:

### 1. Terminal

Connect to the server using `Pretty` by SSH. Here are the software: [putty](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html)

### 2. Rstudio  

An IDE for R, See [here](https://rstudio.com/) for more details. 

[Desktop version](https://rstudio.com/products/rstudio/), choose the Open Source Edition. 

Server version, go to: `http://<ip>:8787` and use your 'username', 'passwd' to login



## II. Using `conda` to manage your software and envs


### 2.1 Installation 

How to install `miniconda`? see [here](https://docs.conda.io/projects/conda/en/latest/user-guide/install/)
and [Installing on Linux](https://docs.conda.io/projects/conda/en/latest/user-guide/install/linux.html)

Find the installer on Yulab server: `/data/biosoft/anaconda/Miniconda3-latest-Linux-x86_64.sh`


Simplify:

```
$ cd ~
$ cp /data/biosoft/anaconda/Miniconda3-latest-Linux-x86_64.sh .
$ bash Miniconda3-latest-Linux-x86_64.sh
```

Following the prompts on the installer.

Add TUNA mirrors, add the following lines in your `~/.condarc` file:

```
channels:
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/bioconda/
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
  - bioconda
  - conda-forge
  - defaults
  - r
  - cgat
show_channel_urls: true
changeps1: true
ssl_verify: true
proxy_servers: {}
```


### 2.2 Install packages with conda 

See [here](https://docs.conda.io/projects/conda/en/latest/user-guide/concepts/installing-with-conda.html)for more details.

Simplify

```
# Search packages
$ conda search bowtie2

# Install bowtie2
$ conda install -c bioconda bowtie2

```

