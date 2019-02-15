# How to build the RPM

- Prepare a linux (e.g. centos)
- Download sonarqube-<version>.zip to ./downloads
- run ./build.sh <version>


## System requirements

- Use a linux capable of running yum
  - To make things easy, run a docker container and map this repository clone for further interactive tasks:
    ```
    docker run -it -v $(pwd):/sonar-rpm centos /bin/bash
    ```
    - Install rpm-build and createrepo
    ```
    yum install rpm-build createrepo
    ```
    - (Or build a new docker image based on the changes below and run build directly)


## Example

With Sonar 7.6 do the following

## Download the Sonar Archive
 
```
cd /sonar-rpm/downloads
curl -L -O https://binaries.sonarsource.com/CommercialDistribution/sonarqube-developer/sonarqube-developer-7.6.zip
cd ..
```

Put the archive into the downloads folder (you may need to rename your distribution to sonarqube-7.6.zip).


## Create the rpm package

```
./build.sh 7.6
```

## Test the rpm package installation locally

```
yum --nogpgcheck localinstall repo/rpm/noarch/sonar-7.6-1.noarch.rpm 
```

## Test the rpm package on a remote repository

<sub>Remark: we neglect GPG checks here; please ensure appropriate GPG key handling in real world scenarios.</sub>

- Deploy the RPM as a new artifact onto any RPM repository, e.g. an Artifactory instance.
- Use a regular yum install
  ````
  yum install sonar-7.6
  ````

- In order to successfully install this with yum a custom repository entry must be created
  - Either as a manual entry in the local system, e.g. /etc/yum.repos.d/<any_name>.repo
    ```
    [sonar]
    name=Sonar
    baseurl=https://<your-custom-rpm-repo-base-uri>/rpm//sonar/
    gpgcheck=0
    ```
  - Or by using IaC tools like Ansible to provide such a repository automatically, e.g.
    ````
    - name: "SonarQube Artifactory RPM Repository is registered as local yum repo"
      yum_repository:
        name: example-org
        description: "Your Artifactory"
        baseurl: "https://artifacts.example.org/rpm/exmple-org/sonar"
        enabled: yes
        gpgcheck: no
        proxy: _none_
    
    - name: "SonarQube server is installed"
      yum:
        update_cache: true
        pkg: "sonar-{{ sonar_version }}"
        state: installed
    ````


