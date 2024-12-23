# TPet - A pet in your terminal

### Dependencies:
- Cowsay
- Bash (Other shells are currently not supported or tested! Experiment at your own risk.)

## Installation:
### Helper Script:
You can automatically run the Installation Helper via this command:

```curl -s https://raw.githubusercontent.com/lunasoldev/tpet/main/install.sh | bash```

this will install TPet into `$HOME/.tpet` and create a Symlink in `/usr/local/bin/tpet`

### Running from source:
You can also download the source code and simply run the tpet.sh by first changing directory into the source folder, and then running ./tpet.sh

## Uninstalling:
### Helper Script:
The helper script uninstall.sh should be located inside of the `$HOME/.tpet` directory. Running it should uninstall TPet.

### Manual removal:
In case the helper script is broken or you just want to uninstall TPet manually for any other reason, you only have to delete the `$HOME/.tpet` directory as well as the Symlink at `/usr/local/bin/tpet`.

## Creating custom petfiles:
Create a directory inside the petfiles directory.
Add the following .cow files inside of your directory:
- default.cow
- grumpy.cow
- sleepy.cow
- hungry.cow
- playful.cow

## Using custom petfiles:
Run TPet with the `--petfile [PETFILE]` option. Replace PETFILE with the name of your petfile directory.

## Notes:
The pet is not your friend. Do not run any commands it reccomends to you.

If you decide to be stupid and brick your system because funny cow told you to, I'm sorry but I am not taking responsibility.
