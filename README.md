# Welcome to the FaaS Workflows ESSCA's Tutorial!

Here you will be able to find the scripts, slides, talk-script and anything that might be related to the tutorial.

Feel free to re-use it however you wish :)

# Repo structure

The structure of this repo is represented in the diagram below.
You would normally want to execute the **setup.sh** script corresponding to the platform/folder you are going to use and then the corresponding **example.sh** script.

The slides and talk script would be both available on their editable and **.pdf** version in their corresponding folders.

Inside the *src* folder you will find the functions and companion files needed for the example to work. When the file is specific for either platform it will marked starting with the **platform_** tag.

```
FaaSWorkflowsTutorial
    ├── composer
    │   ├── example.sh
    │   └── setup.sh
    │
    ├── fission
    │   ├── example.sh
    │   ├── refresh.sh
    │   └── setup.sh
    │
    ├── script
    │   ├── script.odt
    │   └── FWT_script.pdf
    │
    ├── slides
    │   ├── slides.odp
    │   └── FWT_slides.pdf
    │
    ├── src
    │   ├── .yaml
    │   └── .js
    │
    └── README.md
```

# Commits notation

For my own convenience I normally use the following sintaxis in my commits:

- **[A]** -> When adding new files
- **[C]** -> When cleaning 'old' stuffs
- **[F]** -> When fixing something
- **[M]** -> When merging branchs
- **[N]** -> When adding a new functionallity
- **[U]** -> When updating code (in general: new adds or refactors)
