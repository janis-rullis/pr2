# webp-urler / pr2
Serve WEBP images and shorten URLs

## First time? How to set this up?

### [Install docker]((https://github.com/janis-rullis/dev/blob/master/Docker/README.md#install))

Docker is a virtual environment with all the required software included.

### Provide Your environment values

- Copy the `.env.example` to `.env`.
- Open `.env` and fill values in `FILL_THIS`.

### Execute the `setup.sh` script

It will download, install and prepare all the required software.
> Don't worry, later it won't take that long.

> **Note:** It's just a helper that saves You from executing few commands Yourself. In case, if You can't execute it (*on Windows*) or there
> is some trouble, then You can set it up manually as every other Docker + Symfony project.

```shell
./setup.sh
```

### Add these to Your `hosts` file

This transletes the machines address to the domain-name.

```
172.71.3.10     pr2.local
172.71.3.10     pma.pr2.local
```

## Already set-up?

* `start.sh` - Start containers once the setup has been done.
* `test.sh` - Execute PHPUnit tests.

