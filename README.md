<div align="center">
  <h1 align="center"><center>vamp</center></h1>
  <h3 align="center"><center>A package manager for Vala (WIP)</center></h3>
</div>

---

## Planned features

- Fetch and install Vala dependencies from Git URLs
- Integrate with Meson and Flatpak

## Building and running with Docker

You will have to build the containers for each modification. The first time you
launch this command will take a little, so go and grab some coffee.

```bash
docker-compose build
```

After that, you can run the application:

```bash
docker-compose run vamp
```

And the tests:

```bash
docker-compose run tests
```
