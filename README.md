<p align="center">
  <h1 align="center">Petli</h1>
  <p align="center">Virtual Pet in your console. You must feed it, clean up after it, and play with it to keep it happy!</p>
  <p align="center">
    <img src="https://media.giphy.com/media/pwtUe2wVhgpQIK5puU/giphy.gif"/>
  </p>
  <p align="center">
    <a href="https://badge.fury.io/rb/petli"><img src="https://badge.fury.io/rb/petli.svg" alt="Gem Version" height="18"></a>
  </p>
</p>

---
### Usage

Run `gem install petli` and then run `petli` in your command line. Run `petli --help` for more information.

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
$> rake install:local
$> petli
```
