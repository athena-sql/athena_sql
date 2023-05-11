
## Athena Migrate
this tool will helo you create athena.yaml file and run migrations for all packages.

### How to use
to run use:
```bash
dart pub global run athena_migrate [COMMAND]
```

or installed on your devDependencies:
```bash
dart pub add --dev athena_migrate
```
you can run
```bash
dart pub run athena_migrate [COMMAND]
```



comands included:
```bash
  create    Create a new migration file.
  up        One migration up.
```


TODO:
- [ ] add `down` command
- [ ] add `status` command
- [ ] add `reset` command
- [ ] add `refresh` command
- [ ] add `seed` command
- [ ] add `rollback` command
- [ ] add `rollback-all` command
- [ ] add `create:seed` command
