PETLI
-----

Pet line interface (look I know it should have been command line pet like Clipet? Clet? those just don't sound great)

This is a little virtual pet that will live in your console. You must feed it, clean up after it, and play with it to keep it happy!

![image](https://user-images.githubusercontent.com/463193/127347754-a07f71a0-b8c4-4d73-a24f-0bf78fca22b9.png)

### Usage

Run `gem install petli` and then run `petli` in your command line

### Advanced usage

Petli has a command line api that would allow you to do funky things like
- have mutiple pets using `--path`
- make a separate app that graphs happiness using `petli --status | jq '.health`
- setup a cron job to feed your pet hourly with `petli --bread`
- Your idea here!

```
$> petli --help
Usage: petli [options]
    -r, --reset          Reset button to start over again
    -s, --status         Dump pet status
    -b, --bread          Feed your pet bread without viewing
    -c, --candy          Feed your pet candy without viewing
    -m, --medicine       Feed your pet candy without viewing
    -l, --clean          Clean up any 'dirt' without viewing
    -p, --path [PATH]    Path to your pet data (defaults to system config dir)
```

### Development

```bash
$> git clone git@github.com:tanema/petli.git
$> cd petli
$> bundle install
$> rake install
$> petli
```
